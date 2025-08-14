//
//  MarkdownTypewriter.swift
//  SportsDB
//
//  Created by Macbook on 14/8/25.
//

import SwiftUI
import UIKit

// CÁCH 3: Enum để quản lý các mức tốc độ
enum TypingSpeed: Double, CaseIterable {
    case veryFast = 0.005
    case fast = 0.01
    case normal = 0.05
    case slow = 0.1
    case verySlow = 0.2
}

// MARK: - Fixed Custom Markdown View với proper auto-scroll
struct MarkdownTypewriterView: View {
    @Binding var streamText: String
    var typingSpeed: TypingSpeed = .fast
    @State private var displayedText: String = ""
    @State private var typewriterTimer: Timer?
    @State private var currentIndex: String.Index?
    @State private var lastScrollId: UUID?
    @State private var isTypewriting: Bool = false
    @State private var scrollProxy: ScrollViewProxy?
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(parseMarkdownSections(displayedText), id: \.id) { section in
                        section.view
                            .id(section.id)
                            .animation(.easeInOut(duration: 0.1), value: displayedText)
                    }
                }
                .padding(.horizontal, 0)
                .background(
                    GeometryReader { proxy in
                        Color.clear.onAppear {
                            contentHeight = proxy.size.height
                        }
                        .onChange(of: proxy.size.height) { oldVL, newValue in
                            contentHeight = newValue
                        }
                    }
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .id("bottom_anchor")

            }
            .onAppear {
                scrollProxy = proxy
            }
            .onChange(of: streamText) { oldValue, newValue in
                handleStreamTextChange(oldValue: oldValue, newValue: newValue)
            }
            .onChange(of: contentHeight) { _, _ in
                guard isTypewriting else { return }
                withAnimation {
                    proxy.scrollTo("bottom_anchor", anchor: .bottom)
                }
            }
        }
        .onDisappear {
            stopTypewriter()
        }
    }
    
    private func handleStreamTextChange(oldValue: String, newValue: String) {
        // If we have new content from stream
        if newValue != oldValue {
            if isTypewriting {
                // If currently typewriting, just update the target
                // The typewriter will catch up
                return
            } else {
                // Start typewriting from current position
                startTypewriterEffect()
            }
        }
    }

    private func startTypewriterEffect() {
        guard !streamText.isEmpty else { return }
        
        stopTypewriter() // Stop any existing timer
        
        // Set starting index if not set
        if currentIndex == nil {
            currentIndex = streamText.startIndex
            displayedText = ""
        } else if let index = currentIndex, index >= streamText.endIndex {
            // Already at the end, update the index to match new content length
            currentIndex = displayedText.endIndex
        }
        
        // Only start if there's content to display
        guard let startIndex = currentIndex, startIndex < streamText.endIndex else {
            return
        }
        
        isTypewriting = true
        
        // dèault typingSpeed = 0.01 giây = hiển thị ~100 ký tự/giây (rất nhanh)
        typewriterTimer = Timer.scheduledTimer(withTimeInterval: typingSpeed.rawValue, repeats: true) { _ in
            guard let index = currentIndex, index < streamText.endIndex else {
                isTypewriting = false
                stopTypewriter()
                return
            }
            
            let nextIndex = streamText.index(after: index)
            displayedText = String(streamText[..<nextIndex])
            currentIndex = nextIndex
        }
    }
    
    private func stopTypewriter() {
        typewriterTimer?.invalidate()
        typewriterTimer = nil
        isTypewriting = false
    }
}

// MARK: - Markdown Parser Helper
struct MarkdownSection {
    let id = UUID()
    let view: AnyView
}

func parseMarkdownSections(_ text: String) -> [MarkdownSection] {
    let lines = text.components(separatedBy: .newlines)
    var sections: [MarkdownSection] = []
    var i = 0
    
    while i < lines.count {
        let line = lines[i]
        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedLine.isEmpty {
            sections.append(MarkdownSection(view: AnyView(
                Spacer().frame(height: 8)
            )))
        } else if trimmedLine.hasPrefix("```") {
            // Code block
            let language = String(trimmedLine.dropFirst(3)).trimmingCharacters(in: .whitespacesAndNewlines)
            var codeLines: [String] = []
            i += 1
            
            while i < lines.count && !lines[i].trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("```") {
                codeLines.append(lines[i])
                i += 1
            }
            
            let codeContent = codeLines.joined(separator: "\n")
            sections.append(MarkdownSection(view: AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    if !language.isEmpty {
                        HStack {
                            Text(language.uppercased())
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.secondary.opacity(0.1))
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(codeContent)
                            //.font(.system(size: 13, family: .monospaced))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .padding(12)
                    }
                }
                .background(Color.secondary.opacity(0.05))
                .cornerRadius(8)
                .padding(.vertical, 4)
            )))
        } else if trimmedLine.hasPrefix("#### ") {
            // Header 4
            let content = String(trimmedLine.dropFirst(5))
            sections.append(MarkdownSection(view: AnyView(
                Text(parseInlineMarkdown(content))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                    .padding(.top, 6)
                    .padding(.bottom, 2)
            )))
        } else if trimmedLine.hasPrefix("### ") {
            // Header 3
            let content = String(trimmedLine.dropFirst(4))
            sections.append(MarkdownSection(view: AnyView(
                Text(parseInlineMarkdown(content))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(.top, 8)
                    .padding(.bottom, 2)
            )))
        } else if trimmedLine.hasPrefix("## ") {
            // Header 2
            let content = String(trimmedLine.dropFirst(3))
            sections.append(MarkdownSection(view: AnyView(
                Text(parseInlineMarkdown(content))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 12)
                    .padding(.bottom, 4)
            )))
        } else if trimmedLine.hasPrefix("# ") {
            // Header 1
            let content = String(trimmedLine.dropFirst(2))
            sections.append(MarkdownSection(view: AnyView(
                Text(parseInlineMarkdown(content))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 16)
                    .padding(.bottom, 6)
            )))
        } else if trimmedLine.hasPrefix("---") || trimmedLine.hasPrefix("***") {
            // Horizontal rule
            sections.append(MarkdownSection(view: AnyView(
                Divider()
                    .padding(.vertical, 8)
            )))
        } else if let match = trimmedLine.range(of: #"^\d+\.\s"#, options: .regularExpression) {
            // Numbered list
            let content = String(trimmedLine[match.upperBound...])
            let number = String(trimmedLine[..<match.upperBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            
            sections.append(MarkdownSection(view: AnyView(
                HStack(alignment: .top, spacing: 8) {
                    Text(number)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.top, 1)
                        .frame(minWidth: 20, alignment: .trailing)
                    
                    Text(parseInlineMarkdown(content))
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(.leading, 8)
            )))
        } else if trimmedLine.hasPrefix("- ") || trimmedLine.hasPrefix("* ") || trimmedLine.hasPrefix("+ ") {
            // Bullet points
            let content = String(trimmedLine.dropFirst(2))
            sections.append(MarkdownSection(view: AnyView(
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.top, 1)
                    
                    Text(parseInlineMarkdown(content))
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(.leading, 8)
            )))
        } else if trimmedLine.hasPrefix("> ") {
            // Quote/blockquote
            let content = String(trimmedLine.dropFirst(2))
            sections.append(MarkdownSection(view: AnyView(
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.blue.opacity(0.4))
                        .frame(width: 3)
                    
                    Text(parseInlineMarkdown(content))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .italic()
                    
                    Spacer()
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.secondary.opacity(0.05))
                .cornerRadius(4)
            )))
        } else if trimmedLine.hasPrefix("| ") && trimmedLine.hasSuffix(" |") {
            // Table (simplified - collect all table rows)
            var tableRows: [String] = []
            var j = i
            
            while j < lines.count {
                let tableLine = lines[j].trimmingCharacters(in: .whitespacesAndNewlines)
                if tableLine.hasPrefix("| ") && tableLine.hasSuffix(" |") {
                    tableRows.append(tableLine)
                    j += 1
                } else if tableLine.hasPrefix("|") && tableLine.contains("-") {
                    // Skip separator row
                    j += 1
                } else {
                    break
                }
            }
            
            if !tableRows.isEmpty {
                sections.append(MarkdownSection(view: AnyView(
                    createTableView(rows: tableRows)
                )))
                i = j - 1
            }
        } else {
            // Regular text with enhanced paragraph handling
            var paragraph = trimmedLine
            var j = i + 1
            
            // Collect consecutive non-empty lines as one paragraph
            while j < lines.count {
                let nextLine = lines[j].trimmingCharacters(in: .whitespacesAndNewlines)
                if !nextLine.isEmpty &&
                   !nextLine.hasPrefix("#") &&
                   !nextLine.hasPrefix("-") &&
                   !nextLine.hasPrefix("*") &&
                   !nextLine.hasPrefix(">") &&
                   !nextLine.hasPrefix("```") {
                    paragraph += " " + nextLine
                    j += 1
                } else {
                    break
                }
            }
            
            sections.append(MarkdownSection(view: AnyView(
                Text(parseInlineMarkdown(paragraph))
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
            )))
            
            i = j - 1
        }
        
        i += 1
    }
    
    return sections
}

// MARK: - Table View Helper
func createTableView(rows: [String]) -> some View {
    VStack(spacing: 0) {
        ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
            let cells = row.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
            
            HStack(spacing: 0) {
                ForEach(Array(cells.enumerated()), id: \.offset) { cellIndex, cell in
                    Text(parseInlineMarkdown(cell))
                        .font(.system(size: 13, weight: index == 0 ? .semibold : .regular))
                        .foregroundColor(index == 0 ? .primary : .primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if cellIndex < cells.count - 1 {
                        Divider()
                    }
                }
            }
            .background(index == 0 ? Color.secondary.opacity(0.1) : Color.clear)
            
            if index < rows.count - 1 {
                Divider()
            }
        }
    }
    .overlay(
        Rectangle()
            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
    )
    .cornerRadius(6)
    .padding(.vertical, 4)
}

// MARK: - Complete Inline Markdown Parser
func parseInlineMarkdown(_ text: String) -> AttributedString {
    var result = text
    var ranges: [(NSRange, (AttributedString) -> AttributedString)] = []
    
    // 1. Parse code spans first (`code`)
    let codePattern = "`([^`]+)`"
    if let codeRegex = try? NSRegularExpression(pattern: codePattern, options: []) {
        let matches = codeRegex.matches(in: result, options: [], range: NSRange(0..<result.utf16.count))
        for match in matches.reversed() {
            if let range = Range(match.range, in: result),
               let contentRange = Range(match.range(at: 1), in: result) {
                let codeText = String(result[contentRange])
                ranges.append((match.range, { _ in
                    var attr = AttributedString(codeText)
                    //attr.font = .system(size: 13, family: .monospaced)
                    attr.backgroundColor = Color.secondary.opacity(0.15)
                    return attr
                }))
                result.replaceSubrange(range, with: String(repeating: " ", count: match.range.length))
            }
        }
    }
    
    // 2. Parse links [text](url)
    let linkPattern = "\\[([^\\]]+)\\]\\(([^\\)]+)\\)"
    if let linkRegex = try? NSRegularExpression(pattern: linkPattern, options: []) {
        let matches = linkRegex.matches(in: result, options: [], range: NSRange(0..<result.utf16.count))
        for match in matches.reversed() {
            if let textRange = Range(match.range(at: 1), in: result) {
                let linkText = String(result[textRange])
                ranges.append((match.range, { _ in
                    var attr = AttributedString(linkText)
                    attr.foregroundColor = .blue
                    attr.underlineStyle = .single
                    return attr
                }))
                result.replaceSubrange(Range(match.range, in: result)!, with: String(repeating: " ", count: match.range.length))
            }
        }
    }
    
    // 3. Parse bold text (**text** or __text__)
    let boldPatterns = ["\\*\\*((?:[^*]|\\*(?!\\*))+)\\*\\*", "__((?:[^_]|_(?!_))+)__"]
    for pattern in boldPatterns {
        if let boldRegex = try? NSRegularExpression(pattern: pattern, options: []) {
            let matches = boldRegex.matches(in: result, options: [], range: NSRange(0..<result.utf16.count))
            for match in matches.reversed() {
                if let contentRange = Range(match.range(at: 1), in: result) {
                    let boldText = String(result[contentRange])
                    ranges.append((match.range, { _ in
                        var attr = AttributedString(boldText)
                        attr.font = .system(size: 14, weight: .bold)
                        return attr
                    }))
                    result.replaceSubrange(Range(match.range, in: result)!, with: String(repeating: " ", count: match.range.length))
                }
            }
        }
    }
    
    // 4. Parse italic text (*text* or _text_)
    let italicPatterns = ["(?<!\\*)\\*([^*\\s][^*]*[^*\\s]|[^*\\s])\\*(?!\\*)", "(?<!_)_([^_\\s][^_]*[^_\\s]|[^_\\s])_(?!_)"]
    for pattern in italicPatterns {
        if let italicRegex = try? NSRegularExpression(pattern: pattern, options: []) {
            let matches = italicRegex.matches(in: result, options: [], range: NSRange(0..<result.utf16.count))
            for match in matches.reversed() {
                if let contentRange = Range(match.range(at: 1), in: result) {
                    let italicText = String(result[contentRange])
                    ranges.append((match.range, { _ in
                        var attr = AttributedString(italicText)
                        attr.font = .system(size: 14).italic()
                        return attr
                    }))
                    result.replaceSubrange(Range(match.range, in: result)!, with: String(repeating: " ", count: match.range.length))
                }
            }
        }
    }
    
    // 5. Parse strikethrough (~~text~~)
    let strikePattern = "~~([^~]+)~~"
    if let strikeRegex = try? NSRegularExpression(pattern: strikePattern, options: []) {
        let matches = strikeRegex.matches(in: result, options: [], range: NSRange(0..<result.utf16.count))
        for match in matches.reversed() {
            if let contentRange = Range(match.range(at: 1), in: result) {
                let strikeText = String(result[contentRange])
                ranges.append((match.range, { _ in
                    var attr = AttributedString(strikeText)
                    attr.strikethroughStyle = .single
                    attr.foregroundColor = .secondary
                    return attr
                }))
                result.replaceSubrange(Range(match.range, in: result)!, with: String(repeating: " ", count: match.range.length))
            }
        }
    }
    
    // Build final AttributedString
    var finalAttributedString = AttributedString(text)
    
    // Sort ranges by position (reversed to apply from end to start)
    ranges.sort { $0.0.location > $1.0.location }
    
    for (range, transformer) in ranges {
        if let swiftRange = Range(range, in: text),
           let attrRange = Range(swiftRange, in: finalAttributedString) {
            let transformedAttr = transformer(finalAttributedString)
            finalAttributedString.replaceSubrange(attrRange, with: transformedAttr)
        }
    }
    
    return finalAttributedString
}
