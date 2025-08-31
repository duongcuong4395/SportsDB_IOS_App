//
//  SportDBView.swift
//  SportsDB
//
//  Created by Macbook on 5/6/25.
//

import SwiftUI
import SwiftData


struct SportDBView: View {
    @StateObject private var container = AppDependencyContainer()
    @Environment(\.isNetworkConnected) private var isConnected
    @Environment(\.connectionType) private var connectionType
    
    var body: some View {
        VStack(spacing: 0) {
            GenericNavigationStack(
                router: container.sportRouter
             , rootContent: {
                 ListCountryRouteView()
                     .backgroundGradient()
             }
             , destination: sportDestination
            )
        }
        .padding(0)
        
        .overlay(alignment: .bottomLeading, content: {
            bottomOverlay
        })
        .overlay(content: {
            DialogView()
                .environmentObject(container.aiManageVM)
        })
        .injectDependencies(container)
        .onAppear(perform: container.appAppear)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToEvent"))) { notification in
            
            container.handleNavigateToEvent(from: notification)
        }
        .onChange(of: container.notificationListVM.tappedNotification) { oldVL, notification in
            if let notification = notification {
                handleTappedNotification(notification)
            }
        }
        .sheet(isPresented: .constant(!(isConnected ?? true))) {
            NoInternetView()
                .presentationDetents([.height(310)])
                .presentationCornerRadius(0)
                .presentationBackgroundInteraction(.disabled)
                .presentationBackground(.clear)
                .interactiveDismissDisabled()
        }
    }
       
   private func handleTappedNotification(_ notification: NotificationItem) {
       // Xử lý khi có notification được tap
       print("📱 Notification tapped in UI: \(notification.title)")
       
       // Có thể show alert, navigation, etc.
       if let eventId = notification.userInfo["idEvent"] {
           // Navigate to specific event
           print("Should navigate to event: \(eventId)")
       }
   }
    
}

// MARK: bottomOverlay
extension SportDBView {
    @ViewBuilder
    var bottomOverlay: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    SelectSportView(tappedSport: { sport in
                        container.tapSport()
                    })
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                    
                    NavigationToNotificationView()
                    NavigationToLikedView()
                    
                    //ButtonTestNotificationView()
                }
            }
            //.backgroundGradient()
        }
        
        
        
    }
}

// MARK: Sport Destination View
private extension SportDBView {
    @ViewBuilder
    func sportDestination(_ route: SportRoute) -> some View {
        route.destinationView()
            //.padding(.bottom, 50)
    }
}


struct DialogView: View {
    @EnvironmentObject var appVM: AppViewModel
    var body: some View {
        if appVM.showDialog {
            CustomDialogView(title: appVM.titleDialog, buttonTitle: appVM.titleButonAction, action: {
                withAnimation(.spring()) {
                    appVM.showDialog = false
                }
            }, content: appVM.bodyDialog)
        }
    }
}

struct CustomDialogView: View {
    
    //@Binding var isActive: Bool
    @EnvironmentObject var appVM : AppViewModel
    
    let title: String
    let buttonTitle: String
    let action: () -> ()
    var content: AnyView
    
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .liquidGlass(intensity: 0.7)
                .onTapGesture {
                    withAnimation(.spring()) {
                        appVM.showDialog.toggle()
                    }
                }
                .ignoresSafeArea(.all)
            
            VStack {
                
                VStack {
                    Text(title)
                        .font(.system(size: 18))
                        .bold()
                    Divider()
                    content
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                // MARK: New background
                .background{
                    Color.clear
                        .liquidGlass(cornerRadius: 25, intensity: 0.1, tintColor: .white, hasShimmer: false, hasGlow: false)
                }
                .background(.ultraThinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                .padding(.top, 15)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .padding(5)
                        .background{
                            Color.clear
                                .liquidGlass(cornerRadius: 25, intensity: 0.5, tintColor: .white, hasShimmer: false, hasGlow: false)
                        }
                        .onTapGesture {
                            withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
                                action()
                            }
                        }
                        .padding(.top, 5)
                }
                
                .shadow(radius: 20)
                .padding(30)
                .padding(.bottom, 50)
                .offset(x: 0, y: offset)
                .onAppear{
                    withAnimation(.spring()) {
                        offset = 0
                    }
                }
            }
        }
    }
    
    func close() {
        withAnimation(.spring()) {
            self.offset = 1000
        }
    }
}



struct TextFieldSearchView: View {
    @State var listModels: [[Any]]
    @Binding var textSearch: String

    @State var showClear: Bool = false
    var body: some View {
        
        
        HStack{
            Image(systemName: "magnifyingglass")
                //.foregroundStyleItemView(by: appVM.appMode)
                .padding(.leading, 5)
            TextField("Enter text", text: $textSearch)
                //.foregroundStyleItemView(by: appVM.appMode)
                
            if showClear {
                if !textSearch.isEmpty {
                    Button(action: {
                        self.textSearch = ""
                        for i in 0..<listModels.count {
                            listModels[i] = []
                        }
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    //.foregroundStyleItemView(by: appVM.appMode)
                    .padding(.trailing, 5)
                }
            }
        }
        //.avoidKeyboard()
        .padding(.vertical, 3)
        .backgroundOfItemTouched(color: .blue, hasShimmer: false)
        //.liquidGlassBlur()
    }
}


struct NavigationToNotificationView: View {
    @EnvironmentObject var notificationListVM: NotificationListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: notificationListVM.notifications.count > 0 ? "bell.fill" : "bell")
                .font(.title3)
                .frame(width: 25, height: 25)
            Text("Notification")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .backgroundOfItemTouched()
        /*
        .padding(5)
        .background{
            Color.clear
                .liquidGlass(intensity: 0.3, tintColor: .orange, hasShimmer: true, hasGlow: true)
        }
        .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        */
        .onTapGesture {
            if !sportRouter.isAtNotification {
                sportRouter.navigateToNotification()
            }
        }
        .padding(.top, 5)
        .overlay(alignment: .topTrailing) {
            Color.clear
                .customBadge(notificationListVM.notifications.count)
        }
    }
}


struct NavigationToLikedView: View {
    @EnvironmentObject var eventSwiftDataVM: EventSwiftDataViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    @State private var likedCount: Int = 0
    @State private var shouldBounce: Bool = false
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                Image(systemName: likedCount > 0 ? "heart.fill" : "heart")
                    .font(.title3)
                    .frame(width: 25, height: 25)
                    
                Text("Favotire")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .backgroundOfItemTouched()
            .onTapGesture {
                if !sportRouter.isAtLike {
                    
                    sportRouter.navigateToLike()
                }
            }
        }
        .padding(.top, 5)
        .overlay(alignment: .topTrailing) {
            Color.clear
                .customBadge(likedCount)
        }
        // Listen to changes in eventSwiftDataVM.events
        .onChange(of: eventSwiftDataVM.events.map(\.like)) { oldValues, newValues in
            let newCount = newValues.filter { $0 }.count
            
            if newCount != likedCount {
                withAnimation(.easeInOut(duration: 0.3)) {
                    likedCount = newCount
                }
                
                // Trigger bounce animation
                triggerBounce()
            }
        }
        .onAppear {
            likedCount = eventSwiftDataVM.getEventsLiked().count
        }
    }
    
    func getNumberEventsLiked() -> Int {
        withAnimation {
            return eventSwiftDataVM.getEventsLiked().count
        }
        
    }
    
    private func triggerBounce() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            shouldBounce = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                shouldBounce = false
            }
        }
    }
}
