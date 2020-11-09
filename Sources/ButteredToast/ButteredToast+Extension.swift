//
//  ButteredToastModifier.swift
//
//
//  Created by Yon Montoto 11/05/20.
//  Copyright © 2020 Yon Montoto. All rights reserved.
//

import SwiftUI

extension View {
    
    ///  Add this modifier to the top most  views in hierarchy.
    ///  Parameters:
    ///   - isPresented: binding to determine if the toast is showing or not.
    ///   - type: set type of view: alert, toast, or card.
    ///   - position: top or bottom.
    ///   - animation: custom animation.
    ///   - duration: delay for message to stay on screen.
    ///   - closeOnTap: whether you want the message to disappear if you tap on it.
    ///   - onTap: on message view tap perform any action or navigation (this will be good for showing controllers and whatnot)
    ///   - view: view you want to display on your toast view
    /// - Returns: void to View
    public func presentToast<ButteredToastContent: View>( isPresented: Binding<Bool>, type: ButteredToast<ButteredToastContent>.ToastType = .alert, position: ButteredToast<ButteredToastContent>.Position = .bottom, animation: Animation = Animation.easeInOut(duration: 0.3), duration: Double? = 3.0, closeOnTap: Bool = true, onTap: (() -> Void)? = nil, view: @escaping () -> ButteredToastContent) -> some View {
        self.modifier(
            ButteredToast(isPresented: isPresented, type: type, position: position, animation: animation, duration: duration, closeOnTap: closeOnTap, onTap: onTap ?? {}, view: view)
        )
    }
}
