//
//  ButteredToast.swift
//
//  Created by Yon Montoto on 11/04/20.
//  Copyright © 2020 Yon Montoto. All rights reserved.
//

import SwiftUI

public struct ButteredToast<ButteredToastContent>: ViewModifier where ButteredToastContent: View {
    
    public enum ToastType: Equatable {
        case alert
        case toast
        case card(padding: CGFloat = 50)
        
        func shouldBeCentered() -> Bool {
            switch self {
            case .alert:
                return true
            default:
                return false
            }
        }
    }
    
    public enum Position {
        case top
        case bottom
    }
    
    // MARK: - ButteredToast Public Properties
    
    @Binding var isPresented: Bool
    
    var type: ToastType
    var position: Position
    
    var animation: Animation
    var duration: Double?
    var closeOnTap: Bool
    
    private var toastRequestHandler: DispatchWorkItem {
        return DispatchWorkItem {
            toastRequestHandler.cancel()
            isPresented = false
        }
    }
    
    var onTap: () -> Void
    var view: () -> ButteredToastContent
    
    
    // MARK: - Private Properties
    
    /// The space of the HostingController
    @State private var containerRectangle: CGRect = .zero
    
    /// The space of toast content
    @State private var contentRectangle: CGRect = .zero
    
    
    /// This is the offset when the ButteredToast is displayed. We'll keep it private to avoid unwanted effects.
    private var shownOffset: CGFloat {
        switch type {
        case .alert:
            return  -containerRectangle.midY + screenHeight / 2
        case .toast:
            return position == .bottom ? screenHeight - containerRectangle.midY - contentRectangle.height / 2 :
                -containerRectangle.midY + contentRectangle.height / 2
        case .card(let padding):
            return position == .bottom ? screenHeight - containerRectangle.midY - contentRectangle.height / 2 - padding :
                -containerRectangle.midY + contentRectangle.height / 2 + padding
        }
    }
    
    /// This is the offset when the ButteredToast is hidden. We'll keep it private to avoid unwanted effects.
    private var hiddenOffset: CGFloat {
        if position == .top {
            return containerRectangle.isEmpty ? -screenHeight :
                -containerRectangle.midY - contentRectangle.height / 2 - 5
        } else {
            return containerRectangle.isEmpty ? screenHeight + screenHeight :
                screenHeight - containerRectangle.midY + contentRectangle.height / 2 + 5
        }
    }
    
    /// The current offset of the presented property
    private var currentOffset: CGFloat {
        return isPresented ? shownOffset : hiddenOffset
    }
    
    private var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    // MARK: - Content Builders
    
    public func body(content: Content) -> some View {
        content
            .background( GeometryReader { proxy -> AnyView in
                let rectangle = proxy.frame(in: .global)
                if rectangle.integral != self.containerRectangle.integral {
                    DispatchQueue.main.async {
                        self.containerRectangle = rectangle
                    }
                }
                return AnyView(EmptyView())
            })
            .overlay(showToast())
    }
    
    /// This creates your toast View. Buttery smooth..
    func showToast() -> some View {
        
        if let duration = duration {
            if isPresented { DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: toastRequestHandler) }
        }
        
        return ZStack {
            Group {
                VStack {
                    VStack {
                        self.view()
                            .simultaneousGesture(TapGesture(count: 1).onEnded {
                                if self.closeOnTap {
                                    self.isPresented = false
                                    self.onTap()
                                }
                            })
                            .background( GeometryReader { proxy -> AnyView in
                                let rectangle = proxy.frame(in: .global)
                                // This avoids an infinite layout loop
                                if rectangle.integral != self.contentRectangle.integral {
                                    DispatchQueue.main.async {
                                        self.contentRectangle = rectangle
                                    }
                                }
                                return AnyView(EmptyView())
                            })
                    }
                }
                .frame(width: type == .card() ? screenWidth - 30 : screenWidth)
                .offset(x: 0, y: currentOffset)
                .animation(animation)
            }
        }
    }
}
