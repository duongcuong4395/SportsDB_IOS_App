//
//  DialogView.swift
//  SportsDB
//
//  Created by Macbook on 1/9/25.
//

import SwiftUI

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
    @EnvironmentObject var appVM : AppViewModel
    
    let title: String
    let buttonTitle: String
    let action: () -> ()
    var content: AnyView
    
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .themedBackground(.card(intensity: 0.3, tintColor: .white, material: .none))
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
                .themedBackground(.card(tintColor: .white, material: .none))
                .padding(.top, 15)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .padding(5)
                        .themedBackground(.button(tintColor: .white, material: .none))
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
