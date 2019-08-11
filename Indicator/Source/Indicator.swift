//
//  Indicator.swift
//  GYUIComponents
//
//  Created by wanggang on 28/12/2016.
//  Copyright © 2016 ZBJ. All rights reserved.
//

import UIKit

public enum Delay {
    public static let short: TimeInterval = 1.5
    public static let long: TimeInterval = 3.0
}

public final class Indicator {
    
    public static func show(_ indicator: Indicative,
                            inView view: UIView? = nil,
                            delay: TimeInterval = 0,
                            options: IndicatorOptions = [],
                            execute: (() -> Void)? = nil) {
        
        guard let view = view ?? UIApplication.shared.keyWindow else { return }
        
        var object = IndicatorObject(indicator)
        
        options.forEach { optionItem in
            switch optionItem {
            case .appearance(let value):  object.appearance = value
            case .indicatorView(let value): object.indicatorView = value
            case .maskStyle(let value): object.maskStyle = value
            case .position(let value): object.position = value
            case .interactionType(let value): object.interactionType = value
            case .transition(let value): object.transition = value
            }
        }
        
        func doDelay() {
            guard delay > 0 else { return }
            let indicatorMaskView = view.indicatorMaskViews.last
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                guard indicatorMaskView?.superview != nil else { return }
                hide(in: view)
                execute?()
            }
        }
            
       DispatchQueue.main.async {
            let maskView = indicator.maskView(for: view)
            if !view.indicatorMaskViews.isEmpty {
                view.indicatorMaskViews.forEach { $0.removeFromSuperview() }
                view.addSubview(maskView)
                doDelay()
            } else {
                indicator.transition.value.show(indicatorView: maskView.indicatorView, maskView: maskView, inView: view) { _ in
                    doDelay()
                }
            }
            view._indicator = object
        }
    }
    
    public static func hide(in view: UIView? = nil, execute: (() -> Void)? = nil) {
        
        DispatchQueue.main.async {
            
            guard let view = view ?? UIApplication.shared.keyWindow else { return }
            
            if let previousIndicator = view._indicator {
                view.indicatorMaskViews.forEach { maskView in
                    previousIndicator.transition.value.hiden(indicatorView: maskView.indicatorView, maskView: maskView, inView: view) { _ in
                        execute?()
                    }
                }
            }
            view._indicator = nil
        }
    }
}

