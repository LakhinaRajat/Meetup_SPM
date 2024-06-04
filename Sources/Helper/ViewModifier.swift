//
//  ViewModifier.swift
//  LoktantramMeetup
//
//  Created by Loktantram on 19/07/23.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    
    @State private var didLoad = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}


struct HiddenModifier: ViewModifier {
    var isHide:Binding<Bool>
    
    func body(content: Content) -> some View {
        if isHide.wrappedValue{
            content
                .hidden()
        }
        else{
            content
        }
    }
}

extension View {
    
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
    
    func hiddenModifier(isHide:Binding<Bool>) -> some View{
        return self.modifier(HiddenModifier(isHide: isHide))
    }
    
}

public extension Color {

    static let MUGreen = Color("MUGreen")
    static let lkRed = Color("LKRed")
    static let lkDarkRed = Color("lkDarkRed")
    static let lkGray1 = Color("lkGray1")
    static let lkGray2 = Color("lkGray2")
    static let lkGray3 = Color("lkGray3")
    
    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }

}
