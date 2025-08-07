//
//  MorphingButton.swift
//  SportsDB
//
//  Created by Macbook on 6/8/25.
//

import SwiftUI

struct MorphingButton<Label: View, Content: View, ExpandedContent: View>: View {
    var backgroundColor: Color
    @Binding var showExpandedContent: Bool
    @Binding var showFullScreenCover: Bool
    @ViewBuilder var label: Label
    @ViewBuilder var content: Content
    @ViewBuilder var expandedContent: ExpandedContent

    // View Properties
    
    @State private var animateContent: Bool = false
    @State private var viewPosition: CGRect = .zero

    var body: some View {
        label
            //.background(.ultraThinMaterial, in: Circle())
            //.background(backgroundColor)
            //.clipShape(.circle)
            //.contentShape(.circle)
            .onGeometryChange(for: CGRect.self, of: {
                $0.frame(in: .global)
            }, action: { newValue in
                viewPosition = newValue
            })
            .opacity(showFullScreenCover ? 0 : 1)
            .padding(.trailing, 5)
            .padding(.bottom, 5)
            .onTapGesture {
                toggleFullScreenCover(false, status: true)
            }
            .fullScreenCover(isPresented: $showFullScreenCover) {
                ZStack(alignment: .topLeading) {
                    if animateContent {
                        ZStack(alignment: .top) {
                            if showExpandedContent {
                                expandedContent
                                    .transition(.blurReplace)
                            } else {
                                content
                                    .transition(.blurReplace)
                            }
                        }
                        .transition(.blurReplace)
                    } else {
                        label
                            //.transition(.blurReplace)
                    }
                }
                .geometryGroup()
                .clipShape(.rect(cornerRadius: 30, style: .continuous))
                //.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                /*
                .background {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(backgroundColor)
                        .ignoresSafeArea()
                }
                */
                .padding(.horizontal, animateContent && !showExpandedContent ? 15 : 0)
                .padding(.bottom, animateContent && !showExpandedContent ? 5 : 0)
                .frame(
                    maxWidth: .infinity
                    , maxHeight: .infinity
                    , alignment: animateContent ? .bottom : .topLeading)
                .offset(x: animateContent ? 0 : viewPosition.minX,
                        y: animateContent ? 0 : viewPosition.minY
                )
                .ignoresSafeArea(animateContent ? [] : .all)
                
                .background {
                    Rectangle()
                    
                        .fill(.black.opacity(animateContent ? 0.01 : 0))
                        .background(.ultraThinMaterial.opacity(0.3))
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0),
                                          completionCriteria: .removed) {
                                animateContent = false
                            } completion: {
                                /// Removing Sheet After a little delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    toggleFullScreenCover(false, status: false)
                                }
                            }
                        }
                }
                .task {
                    try? await Task.sleep(for: .seconds(0.05))
                    withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
                        animateContent = true
                    }
                }
                .animation(.interpolatingSpring(duration: 0.2, bounce: 0), value: showExpandedContent)
                .presentationBackground(.clear)
            }
    }

    private func toggleFullScreenCover(_ withAnimation: Bool, status: Bool) {
        var transaction = Transaction()
        transaction.disablesAnimations = !withAnimation

        withTransaction(transaction) {
            showFullScreenCover = status
        }
    }
}




enum AnimationDirection1 {
    case leftToRight, rightToLeft, topToBottom, bottomToTop
}

// MARK: New version
import SwiftUI

// MARK: - Configuration
struct MorphingButtonConfig {
    let animationDuration: Double = 0.3
    let cornerRadius: CGFloat = 30
    let horizontalPadding: CGFloat = 15
    let bottomPadding: CGFloat = 5
    let trailingPadding: CGFloat = 5
    let springResponse: Double = 0.6
    let springDampingFraction: Double = 0.8
}

// MARK: - Morphing States
enum MorphingState {
    case collapsed
    case expanding
    case expanded
    case expandedContent
}

// MARK: - Improved MorphingButton
struct MorphingButton_New<Label: View, Content: View, ExpandedContent: View>: View {
    // MARK: - Public Properties
    let backgroundColor: Color
    @Binding var showExpandedContent: Bool
    @ViewBuilder let label: Label
    @ViewBuilder let content: Content
    @ViewBuilder let expandedContent: ExpandedContent
    
    // MARK: - Configuration
    private let config = MorphingButtonConfig()
    
    // MARK: - Private State
    @State private var morphingState: MorphingState = .collapsed
    @State private var labelFrame: CGRect = .zero
    @State private var isAnimating: Bool = false
    
    // MARK: - Computed Properties
    private var isExpanded: Bool {
        morphingState == .expanded || morphingState == .expandedContent
    }
    
    private var shouldShowOverlay: Bool {
        morphingState != .collapsed
    }
    
    var body: some View {
        ZStack {
            // Background overlay when expanded
            if shouldShowOverlay {
                backgroundOverlay
            }
            
            // Main morphing content
            morphingContent
        }
        .onGeometryChange(for: CGRect.self) { geometry in
            geometry.frame(in: .global)
        } action: { frame in
            if morphingState == .collapsed {
                labelFrame = frame
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to expand")
    }
    
    // MARK: - Background Overlay
    private var backgroundOverlay: some View {
        Rectangle()
            .fill(.black.opacity(isExpanded ? 0.3 : 0))
            .background(.ultraThinMaterial.opacity(isExpanded ? 0.5 : 0))
            .ignoresSafeArea()
            .onTapGesture {
                collapse()
            }
            .transition(.opacity)
    }
    
    // MARK: - Main Morphing Content
    private var morphingContent: some View {
        Group {
            switch morphingState {
            case .collapsed:
                collapsedView
            case .expanding:
                expandingView
            case .expanded:
                expandedView
            case .expandedContent:
                expandedContentView
            }
        }
        .animation(.spring(response: config.springResponse, dampingFraction: config.springDampingFraction), value: morphingState)
        .animation(.spring(response: config.springResponse, dampingFraction: config.springDampingFraction), value: showExpandedContent)
    }
    
    // MARK: - View States
    private var collapsedView: some View {
        label
            .background(backgroundColor, in: Circle())
            .clipShape(Circle())
            .contentShape(Circle())
            .padding(.trailing, config.trailingPadding)
            .padding(.bottom, config.bottomPadding)
            .onTapGesture {
                expand()
            }
    }
    
    private var expandingView: some View {
        label
            .background(backgroundColor, in: Circle())
            .clipShape(Circle())
            .position(x: labelFrame.midX, y: labelFrame.midY)
    }
    
    private var expandedView: some View {
        content
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous))
            .padding(.horizontal, config.horizontalPadding)
            .padding(.bottom, config.bottomPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    private var expandedContentView: some View {
        expandedContent
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .transition(.blurReplace.combined(with: .scale))
    }
    
    // MARK: - Animation Methods
    private func expand() {
        guard !isAnimating else { return }
        
        withAnimation(.spring(response: config.springResponse, dampingFraction: config.springDampingFraction)) {
            isAnimating = true
            morphingState = .expanding
        }
        
        // Delay for smooth transition
        DispatchQueue.main.asyncAfter(deadline: .now() + config.animationDuration / 2) {
            withAnimation(.spring(response: config.springResponse, dampingFraction: config.springDampingFraction)) {
                morphingState = .expanded
                isAnimating = false
            }
        }
    }
    
    private func collapse() {
        guard !isAnimating else { return }
        
        withAnimation(.spring(response: config.springResponse, dampingFraction: config.springDampingFraction)) {
            isAnimating = true
            showExpandedContent = false
            morphingState = .expanding
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + config.animationDuration / 2) {
            withAnimation(.spring(response: config.springResponse, dampingFraction: config.springDampingFraction)) {
                morphingState = .collapsed
                isAnimating = false
            }
        }
    }
    
    // MARK: - State Change Handler
    private func handleExpandedContentChange() {
        guard isExpanded else { return }
        
        withAnimation(.spring(response: config.springResponse, dampingFraction: config.springDampingFraction)) {
            morphingState = showExpandedContent ? .expandedContent : .expanded
        }
    }
}

// MARK: - Custom Transitions
extension AnyTransition {
    static var morphingScale: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.8).combined(with: .opacity),
            removal: .scale(scale: 1.2).combined(with: .opacity)
        )
    }
}

// MARK: - Usage Example
struct DemoMorphingView: View {
    @State private var showExpandedContent = false
    @State private var showSecondButton = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                HStack {
                    
                    
                    Spacer()
                    
                    // Second morphing button
                    MorphingButton_New(
                        backgroundColor: .green,
                        showExpandedContent: $showSecondButton,
                        label: {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                        },
                        content: {
                            VStack {
                                Text("Green Content")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Button("Toggle") {
                                    showSecondButton.toggle()
                                }
                                .padding()
                                .background(.white.opacity(0.2))
                                .clipShape(Capsule())
                            }
                            .padding()
                        },
                        expandedContent: {
                            Text("Green Expanded")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                    )
                }
                
                
                
            }
            .overlay(alignment: .bottomLeading) {
                // First morphing button
                MorphingButton_New(
                    backgroundColor: .blue,
                    showExpandedContent: $showExpandedContent,
                    label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                    },
                    content: {
                        VStack(spacing: 20) {
                            Text("Main Content")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Button("Show More") {
                                showExpandedContent.toggle()
                            }
                            .padding()
                            .background(.white.opacity(0.2))
                            .clipShape(Capsule())
                        }
                        .padding()
                    },
                    expandedContent: {
                        VStack(spacing: 30) {
                            Text("Expanded Content")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            ScrollView {
                                LazyVStack(spacing: 15) {
                                    ForEach(1...10, id: \.self) { index in
                                        HStack {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                            Text("Item \(index)")
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        .padding()
                                        .background(.white.opacity(0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                                .padding()
                            }
                            
                            Button("Go Back") {
                                showExpandedContent = false
                            }
                            .padding()
                            .background(.white.opacity(0.2))
                            .clipShape(Capsule())
                        }
                        .padding()
                    }
                )
            }
        }
    }
}
