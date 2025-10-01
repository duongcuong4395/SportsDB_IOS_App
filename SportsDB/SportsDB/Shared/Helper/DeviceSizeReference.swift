//
//  DeviceSizeReference.swift
//  SportsDB
//
//  Created by Macbook on 30/9/25.
//

import SwiftUI

// MARK: - Device Size Reference
/*
 ═══════════════════════════════════════════════════════════════
 📱 IPHONE SIZES (Points - Portrait)
 ═══════════════════════════════════════════════════════════════
 
 iPhone SE (1st, 2nd gen)         320 x 568   @2x
 iPhone SE (3rd gen)               375 x 667   @2x
 iPhone 8, 7, 6s, 6                375 x 667   @2x
 iPhone 8+, 7+, 6s+, 6+            414 x 736   @3x
 iPhone X, XS, 11 Pro, 12 mini     375 x 812   @3x
 iPhone XR, 11, 12, 13, 14         390 x 844   @2x/@3x
 iPhone 12 Pro, 13 Pro, 14 Pro     390 x 844   @3x
 iPhone 14 Plus                    428 x 926   @3x
 iPhone 14 Pro Max, 13 Pro Max     428 x 926   @3x
 iPhone 15, 15 Pro                 393 x 852   @3x
 iPhone 15 Plus, 15 Pro Max        430 x 932   @3x
 
 📊 iPhone Width Breakpoints:
 - Small:  320-375 (SE, 8, X, XS, 11 Pro, 12 mini)
 - Medium: 390-393 (12, 13, 14, 15)
 - Large:  414-430 (Plus, Pro Max models)
 
 ═══════════════════════════════════════════════════════════════
 📱 IPAD SIZES (Points - Portrait)
 ═══════════════════════════════════════════════════════════════
 
 iPad Mini (6th gen)               744 x 1133  @2x
 iPad (9th, 10th gen)              810 x 1080  @2x
 iPad Air (4th, 5th gen)           820 x 1180  @2x
 iPad Pro 11" (1st-4th gen)        834 x 1194  @2x
 iPad Pro 12.9" (1st-6th gen)     1024 x 1366  @2x
 
 📊 iPad Width Breakpoints:
 - Small:  744-820  (Mini, Standard iPad)
 - Medium: 834      (iPad Air, Pro 11")
 - Large:  1024     (iPad Pro 12.9")
 
 ═══════════════════════════════════════════════════════════════
 🎯 RECOMMENDED CONTENT MAX-WIDTHS
 ═══════════════════════════════════════════════════════════════
 
 iPhone:
 - No max-width needed (full screen)
 - For readability: 600pt max for long text
 
 iPad:
 - Forms/Reading:    600-700pt
 - Cards/Grid:       800-1000pt
 - Full layouts:     1200-1400pt
 - Never exceed:     1600pt (too wide)
 
 ═══════════════════════════════════════════════════════════════
*/

// MARK: - Base Device Detection
enum DeviceType {
    case iPhone
    case iPad
    case mac
    
    static var current: DeviceType {
        #if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad ? .iPad : .iPhone
        #elseif os(macOS)
        return .mac
        #endif
    }
}

// MARK: - Screen Size Helper
struct ScreenSize {
    static var width: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        UIScreen.main.bounds.height
    }
}

// MARK: - Enhanced Device Size Detection
enum DeviceSize {
    case iPhoneSmall      // 320-375 (SE, 8, X, XS, 11 Pro, 12 mini)
    case iPhoneMedium     // 390-393 (12, 13, 14, 15)
    case iPhoneLarge      // 414-430 (Plus, Pro Max)
    case iPadSmall        // 744-820 (Mini, iPad)
    case iPadMedium       // 834 (Air, Pro 11")
    case iPadLarge        // 1024+ (Pro 12.9")
    
    static var current: DeviceSize {
        let width = ScreenSize.width
        
        if DeviceType.current == .iPad {
            switch width {
            case ..<830: return .iPadSmall
            case 830..<900: return .iPadMedium
            default: return .iPadLarge
            }
        } else {
            switch width {
            case ..<380: return .iPhoneSmall
            case 380..<400: return .iPhoneMedium
            default: return .iPhoneLarge
            }
        }
    }
    
    var isPhone: Bool {
        switch self {
        case .iPhoneSmall, .iPhoneMedium, .iPhoneLarge:
            return true
        default:
            return false
        }
    }
    
    var isPad: Bool {
        !isPhone
    }
}

// MARK: - Smart Adaptive Values (Apple HIG Compliant)
struct SmartAdaptive {
    
    // SPACING - Dựa trên Apple HIG
    static var tiny: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 4
        case .iPhoneMedium, .iPhoneLarge: return 6
        case .iPadSmall: return 8
        case .iPadMedium: return 10
        case .iPadLarge: return 12
        }
    }
    
    static var small: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 8
        case .iPhoneMedium, .iPhoneLarge: return 10
        case .iPadSmall: return 12
        case .iPadMedium: return 14
        case .iPadLarge: return 16
        }
    }
    
    static var medium: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 12
        case .iPhoneMedium, .iPhoneLarge: return 16
        case .iPadSmall: return 20
        case .iPadMedium: return 24
        case .iPadLarge: return 28
        }
    }
    
    static var large: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 16
        case .iPhoneMedium, .iPhoneLarge: return 20
        case .iPadSmall: return 28
        case .iPadMedium: return 32
        case .iPadLarge: return 40
        }
    }
    
    static var xlarge: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 24
        case .iPhoneMedium, .iPhoneLarge: return 32
        case .iPadSmall: return 40
        case .iPadMedium: return 48
        case .iPadLarge: return 56
        }
    }
    
    // PADDING
    static var containerPadding: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 12
        case .iPhoneMedium, .iPhoneLarge: return 16
        case .iPadSmall: return 24
        case .iPadMedium: return 32
        case .iPadLarge: return 40
        }
    }
    
    static var sectionPadding: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 16
        case .iPhoneMedium, .iPhoneLarge: return 20
        case .iPadSmall: return 32
        case .iPadMedium: return 40
        case .iPadLarge: return 48
        }
    }
    
    // CORNER RADIUS
    static var cornerRadius: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 10
        case .iPhoneMedium, .iPhoneLarge: return 12
        case .iPadSmall: return 14
        case .iPadMedium: return 16
        case .iPadLarge: return 20
        }
    }
    
    static var cardCornerRadius: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 12
        case .iPhoneMedium, .iPhoneLarge: return 16
        case .iPadSmall: return 18
        case .iPadMedium: return 20
        case .iPadLarge: return 24
        }
    }
    
    // FONT SIZES
    static var titleSize: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 28
        case .iPhoneMedium, .iPhoneLarge: return 34
        case .iPadSmall: return 38
        case .iPadMedium: return 42
        case .iPadLarge: return 48
        }
    }
    
    static var headlineSize: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 17
        case .iPhoneMedium, .iPhoneLarge: return 20
        case .iPadSmall: return 22
        case .iPadMedium: return 24
        case .iPadLarge: return 28
        }
    }
    
    static var bodySize: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 15
        case .iPhoneMedium, .iPhoneLarge: return 17
        case .iPadSmall: return 18
        case .iPadMedium: return 19
        case .iPadLarge: return 21
        }
    }
    
    static var captionSize: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 11
        case .iPhoneMedium, .iPhoneLarge: return 12
        case .iPadSmall: return 13
        case .iPadMedium: return 14
        case .iPadLarge: return 15
        }
    }
    
    // GRID COLUMNS
    static var gridColumns: Int {
        switch DeviceSize.current {
        case .iPhoneSmall: return 2
        case .iPhoneMedium, .iPhoneLarge: return 2
        case .iPadSmall: return 3
        case .iPadMedium: return 4
        case .iPadLarge: return 5
        }
    }
    
    // MAX WIDTHS
    static var contentMaxWidth: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall, .iPhoneMedium, .iPhoneLarge:
            return .infinity  // Full width on iPhone
        case .iPadSmall:
            return 600  // Readable width
        case .iPadMedium:
            return 700
        case .iPadLarge:
            return 900  // Comfortable reading
        }
    }
    
    static var formMaxWidth: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall, .iPhoneMedium, .iPhoneLarge:
            return .infinity
        case .iPadSmall:
            return 500
        case .iPadMedium:
            return 600
        case .iPadLarge:
            return 700
        }
    }
    
    static var gridMaxWidth: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall, .iPhoneMedium, .iPhoneLarge:
            return .infinity
        case .iPadSmall:
            return 800
        case .iPadMedium:
            return 1000
        case .iPadLarge:
            return 1200
        }
    }
    
    static var wideLayoutMaxWidth: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall, .iPhoneMedium, .iPhoneLarge:
            return .infinity
        case .iPadSmall:
            return 1000
        case .iPadMedium:
            return 1200
        case .iPadLarge:
            return 1400
        }
    }
    
    // ICON SIZES
    static var iconSize: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 20
        case .iPhoneMedium, .iPhoneLarge: return 24
        case .iPadSmall: return 28
        case .iPadMedium: return 32
        case .iPadLarge: return 36
        }
    }
    
    static var largeIconSize: CGFloat {
        switch DeviceSize.current {
        case .iPhoneSmall: return 40
        case .iPhoneMedium, .iPhoneLarge: return 50
        case .iPadSmall: return 60
        case .iPadMedium: return 70
        case .iPadLarge: return 80
        }
    }
    
    // MINIMUM TAP TARGET (Apple HIG: 44pt minimum)
    static var minTapTarget: CGFloat {
        DeviceType.current == .iPad ? 48 : 44
    }
}

// MARK: - Adaptive Layout Manager
class AdaptiveLayoutManager: ObservableObject {
    @Published var deviceType: DeviceType
    @Published var deviceSize: DeviceSize
    @Published var orientation: UIDeviceOrientation
    @Published var screenWidth: CGFloat
    @Published var screenHeight: CGFloat
    
    init() {
        self.deviceType = DeviceType.current
        self.deviceSize = DeviceSize.current
        self.orientation = UIDevice.current.orientation
        self.screenWidth = ScreenSize.width
        self.screenHeight = ScreenSize.height
        
        NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateDeviceInfo()
        }
    }
    
    private func updateDeviceInfo() {
        orientation = UIDevice.current.orientation
        screenWidth = ScreenSize.width
        screenHeight = ScreenSize.height
        deviceSize = DeviceSize.current
    }
    
    var isLandscape: Bool {
        orientation.isLandscape
    }
    
    var isPortrait: Bool {
        orientation.isPortrait || orientation == .unknown
    }
    
    var isPad: Bool {
        deviceType == .iPad
    }
    
    var isPhone: Bool {
        deviceType == .iPhone
    }
}

// MARK: - View Extensions for Smart Adaptive Design
extension View {
    // Smart Padding
    func smartPadding(_ type: SmartPaddingType = .container) -> some View {
        self.padding(type.value)
    }
    
    func smartPadding(_ edges: Edge.Set, _ type: SmartPaddingType = .container) -> some View {
        self.padding(edges, type.value)
    }
    
    // Smart Spacing
    func smartSpacing(_ type: SmartSpacingType = .medium) -> some View {
        self.modifier(SmartSpacingModifier(spacing: type.value))
    }
    
    // Smart Font
    func smartFont(_ type: SmartFontType, weight: Font.Weight = .regular) -> some View {
        self.font(.system(size: type.value, weight: weight))
    }
    
    // Smart Corner Radius
    func smartCornerRadius(_ type: SmartCornerRadiusType = .standard) -> some View {
        self.cornerRadius(type.value)
    }
    
    // Smart Max Width
    func smartMaxWidth(_ type: SmartMaxWidthType = .content) -> some View {
        self.frame(maxWidth: type.value)
    }
    
    // Device Visibility
    func phoneOnly() -> some View {
        self.modifier(DeviceVisibilityModifier(showOn: .iPhone))
    }
    
    func padOnly() -> some View {
        self.modifier(DeviceVisibilityModifier(showOn: .iPad))
    }
    
    func hideOnSmallPhone() -> some View {
        self.opacity(DeviceSize.current == .iPhoneSmall ? 0 : 1)
    }
}


// MARK: - Smart Padding Types
enum SmartPaddingType {
    case tiny
    case small
    case medium
    case large
    case xlarge
    case container
    case section
    
    var value: CGFloat {
        switch self {
        case .tiny: return SmartAdaptive.tiny
        case .small: return SmartAdaptive.small
        case .medium: return SmartAdaptive.medium
        case .large: return SmartAdaptive.large
        case .xlarge: return SmartAdaptive.xlarge
        case .container: return SmartAdaptive.containerPadding
        case .section: return SmartAdaptive.sectionPadding
        }
    }
}

// MARK: - Smart Spacing Types
enum SmartSpacingType {
    case tiny
    case small
    case medium
    case large
    case xlarge
    
    var value: CGFloat {
        switch self {
        case .tiny: return SmartAdaptive.tiny
        case .small: return SmartAdaptive.small
        case .medium: return SmartAdaptive.medium
        case .large: return SmartAdaptive.large
        case .xlarge: return SmartAdaptive.xlarge
        }
    }
}

struct SmartSpacingModifier: ViewModifier {
    let spacing: CGFloat
    
    func body(content: Content) -> some View {
        content
    }
}

// MARK: - Smart Font Types
enum SmartFontType {
    case title
    case headline
    case body
    case caption
    
    var value: CGFloat {
        switch self {
        case .title: return SmartAdaptive.titleSize
        case .headline: return SmartAdaptive.headlineSize
        case .body: return SmartAdaptive.bodySize
        case .caption: return SmartAdaptive.captionSize
        }
    }
}

// MARK: - Smart Corner Radius Types
enum SmartCornerRadiusType {
    case standard
    case card
    
    var value: CGFloat {
        switch self {
        case .standard: return SmartAdaptive.cornerRadius
        case .card: return SmartAdaptive.cardCornerRadius
        }
    }
}

// MARK: - Smart Max Width Types
enum SmartMaxWidthType {
    case content
    case form
    case grid
    case wide
    case full
    
    var value: CGFloat {
        switch self {
        case .content: return SmartAdaptive.contentMaxWidth
        case .form: return SmartAdaptive.formMaxWidth
        case .grid: return SmartAdaptive.gridMaxWidth
        case .wide: return SmartAdaptive.wideLayoutMaxWidth
        case .full: return .infinity
        }
    }
}

// MARK: - Device Visibility Modifier
struct DeviceVisibilityModifier: ViewModifier {
    let showOn: DeviceType
    
    func body(content: Content) -> some View {
        if DeviceType.current == showOn {
            content
        }
    }
}

// MARK: - Smart Adaptive Stack
struct SmartStack<Content: View>: View {
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: SmartSpacingType
    let content: Content
    
    init(
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        spacing: SmartSpacingType = .medium,
        @ViewBuilder content: () -> Content
    ) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        if DeviceSize.current.isPad {
            HStack(alignment: verticalAlignment, spacing: spacing.value) {
                content
            }
        } else {
            VStack(alignment: horizontalAlignment, spacing: spacing.value) {
                content
            }
        }
    }
}

// MARK: - Smart Grid
struct SmartGrid<Content: View>: View {
    let columns: Int?
    let spacing: SmartSpacingType
    let content: Content
    
    init(
        columns: Int? = nil,
        spacing: SmartSpacingType = .medium,
        @ViewBuilder content: () -> Content
    ) {
        self.columns = columns
        self.spacing = spacing
        self.content = content()
    }
    
    var gridColumns: Int {
        columns ?? SmartAdaptive.gridColumns
    }
    
    var gridItems: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing.value), count: gridColumns)
    }
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: spacing.value) {
            content
        }
    }
}

// MARK: - Smart Container
struct SmartContainer<Content: View>: View {
    let hasScroll: Bool
    let maxWidth: SmartMaxWidthType
    let content: Content
    
    init(
        hasScroll: Bool = false,
        maxWidth: SmartMaxWidthType = .content,
        @ViewBuilder content: () -> Content
    ) {
        self.hasScroll = hasScroll
        self.maxWidth = maxWidth
        self.content = content()
    }
    
    var body: some View {
        if hasScroll {
            ScrollView(showsIndicators: false) {
                content
                    .frame(maxWidth: maxWidth.value)
                    .smartPadding(.container)
            }
            
        } else {
            content
                .frame(maxWidth: maxWidth.value)
                .smartPadding(.container)
        }
        
    }
}

// MARK: - Responsive Container
struct ResponsiveContainer<Content: View>: View {
    let content: Content
    @StateObject private var layoutManager = AdaptiveLayoutManager()
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .environmentObject(layoutManager)
    }
}




// ===============================================

// MARK: - Demo View
struct SmartResponsiveDemo: View {
    @EnvironmentObject var layoutManager: AdaptiveLayoutManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: SmartAdaptive.large) {
                // Header
                SmartContainer(maxWidth: .content) {
                    VStack(spacing: SmartAdaptive.medium) {
                        Text("Smart Responsive System")
                            .smartFont(.title, weight: .bold)
                        
                        Text("Device: \(deviceInfo)")
                            .smartFont(.body)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Device Info Card
                SmartContainer(maxWidth: .form) {
                    VStack(alignment: .leading, spacing: SmartAdaptive.small) {
                        InfoRow(label: "Device Type", value: layoutManager.isPad ? "iPad" : "iPhone")
                        InfoRow(label: "Screen Size", value: screenSizeText)
                        InfoRow(label: "Orientation", value: layoutManager.isLandscape ? "Landscape" : "Portrait")
                        InfoRow(label: "Width", value: "\(Int(layoutManager.screenWidth))pt")
                        InfoRow(label: "Grid Columns", value: "\(SmartAdaptive.gridColumns)")
                    }
                    .smartPadding(.section)
                    .background(Color.blue.opacity(0.1))
                    .smartCornerRadius(.card)
                }
                
                // Adaptive Stack Demo
                Text("Smart Stack Demo")
                    .smartFont(.headline, weight: .semibold)
                
                SmartStack(spacing: .medium) {
                    ForEach(0..<3) { index in
                        RoundedRectangle(cornerRadius: SmartAdaptive.cornerRadius)
                            .fill(Color.purple.opacity(0.6))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text("Box \(index + 1)")
                                    .smartFont(.body, weight: .semibold)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .smartPadding(.container)
                
                // Smart Grid Demo
                Text("Smart Grid Demo")
                    .smartFont(.headline, weight: .semibold)
                
                SmartContainer(maxWidth: .grid) {
                    SmartGrid(spacing: .medium) {
                        ForEach(0..<12) { index in
                            RoundedRectangle(cornerRadius: SmartAdaptive.cardCornerRadius)
                                .fill(Color.green.opacity(0.6))
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                    VStack {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: SmartAdaptive.iconSize))
                                        Text("Item \(index + 1)")
                                            .smartFont(.caption, weight: .medium)
                                    }
                                    .foregroundColor(.white)
                                )
                        }
                    }
                }
                
                // Device Specific Content
                VStack(spacing: SmartAdaptive.medium) {
                    Text("iPhone Only Content")
                        .smartFont(.headline, weight: .semibold)
                        .foregroundColor(.orange)
                        .smartPadding(.medium)
                        .background(Color.orange.opacity(0.2))
                        .smartCornerRadius()
                        .phoneOnly()
                    
                    Text("iPad Only Content")
                        .smartFont(.headline, weight: .semibold)
                        .foregroundColor(.blue)
                        .smartPadding(.medium)
                        .background(Color.blue.opacity(0.2))
                        .smartCornerRadius()
                        .padOnly()
                }
                .smartPadding(.container)
            }
            .smartPadding(.section)
        }
    }
    
    var deviceInfo: String {
        switch DeviceSize.current {
        case .iPhoneSmall: return "iPhone Small"
        case .iPhoneMedium: return "iPhone Medium"
        case .iPhoneLarge: return "iPhone Large"
        case .iPadSmall: return "iPad Small"
        case .iPadMedium: return "iPad Medium"
        case .iPadLarge: return "iPad Large"
        }
    }
    
    var screenSizeText: String {
        let size = DeviceSize.current
        switch size {
        case .iPhoneSmall: return "320-375pt"
        case .iPhoneMedium: return "390-393pt"
        case .iPhoneLarge: return "414-430pt"
        case .iPadSmall: return "744-820pt"
        case .iPadMedium: return "834pt"
        case .iPadLarge: return "1024pt+"
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .smartFont(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .smartFont(.body, weight: .medium)
        }
    }
}

// MARK: - App Entry Point
struct SmartResponsiveApp: View {
    var body: some View {
        ResponsiveContainer {
            SmartResponsiveDemo()
        }
    }
}

/*
// MARK: - Previews
struct SmartResponsiveApp_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SmartResponsiveApp()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
            
            SmartResponsiveApp()
                .previewDevice("iPhone 15 Pro")
                .previewDisplayName("iPhone 15 Pro")
            
            SmartResponsiveApp()
                .previewDevice("iPhone 15 Pro Max")
                .previewDisplayName("iPhone 15 Pro Max")
            
            SmartResponsiveApp()
                .previewDevice("iPad mini (6th generation)")
                .previewDisplayName("iPad Mini")
            
            SmartResponsiveApp()
                .previewDevice("iPad Pro (11-inch) (4th generation)")
                .previewDisplayName("iPad Pro 11\"")
            
            SmartResponsiveApp()
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
                .previewDisplayName("iPad Pro 12.9\"")
        }
    }
}
*/
