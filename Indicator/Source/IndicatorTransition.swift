//
//  IndicatorTransition.swift
//  GYUIComponents
//
//  Created by gang wang on 2019/8/5.
//

import UIKit

public enum IndicatorTransition {
    case none
    case fade
    case curveEaseInOut
    case custom(IndicatorTransitioning)
    
    var value: IndicatorTransitioning {
        switch self {
        case .none:
            return NoneIndicatorTransition()
        case .fade:
            return FadeIndicatorTransition()
        case .curveEaseInOut:
            return EaseInOutIndicatorTransition()
        case .custom(let transition):
            return transition
        }
    }
}

public protocol IndicatorTransitioning: NSObjectProtocol {
    
    var duration: TimeInterval { get }
    
    func show(indicatorView: IndicatorView, maskView: IndicatorMaskView, inView view: UIView, completion: ((Bool) -> Void)?)
    func hiden(indicatorView: IndicatorView, maskView: IndicatorMaskView, inView view: UIView, completion: ((Bool) -> Void)?)
}

extension IndicatorTransitioning {
    public var duration: TimeInterval {
        return 0
    }
}

public class NoneIndicatorTransition: NSObject, IndicatorTransitioning {
    
    public func show(indicatorView: IndicatorView, maskView: IndicatorMaskView, inView view: UIView, completion: ((Bool) -> Void)?) {
        view.addSubview(maskView)
        completion?(true)
    }
    
    public func hiden(indicatorView: IndicatorView, maskView: IndicatorMaskView, inView view: UIView, completion: ((Bool) -> Void)?) {
        maskView.removeFromSuperview()
        completion?(true)
    }
}

public class FadeIndicatorTransition: NSObject, IndicatorTransitioning {
    
    public var duration: TimeInterval = 0.15
    
    public func show(indicatorView: IndicatorView, maskView: IndicatorMaskView, inView view: UIView, completion: ((Bool) -> Void)?) {
        
        indicatorView.alpha = 0
        maskView.alpha = 0

        view.addSubview(maskView)

        UIView.animate(withDuration: duration, animations: {
            maskView.alpha = 1
            indicatorView.alpha = 1
        }) { result in
            completion?(result)
        }
    }
    
    public func hiden(indicatorView: IndicatorView, maskView: IndicatorMaskView, inView view: UIView, completion: ((Bool) -> Void)?) {
        
        UIView.animate(withDuration: duration, animations: {
            maskView.alpha = 0
            indicatorView.alpha = 0
        }) { result in
            maskView.removeFromSuperview()
            completion?(result)
        }
    }
}

public class EaseInOutIndicatorTransition: NSObject, IndicatorTransitioning {
    
    public var duration: TimeInterval = 0.15
    
    public func show(indicatorView: IndicatorView, maskView: IndicatorMaskView, inView view: UIView, completion: ((Bool) -> Void)?) {
        
        indicatorView.alpha = 0
        indicatorView.transform = indicatorView.transform.scaledBy(x: 1.4, y: 1.4)
        maskView.alpha = 0

        view.addSubview(maskView)

        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            maskView.alpha = 1
            indicatorView.transform = indicatorView.transform.scaledBy(x: 1.0 / 1.4, y: 1.0 / 1.4)
            indicatorView.alpha = 1
        }) { result in
            completion?(result)
        }
    }
    
    public func hiden(indicatorView: IndicatorView, maskView: IndicatorMaskView, inView view: UIView, completion: ((Bool) -> Void)?) {
        
        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            maskView.alpha = 0
            indicatorView.transform = indicatorView.transform.scaledBy(x: 0.7, y: 0.7)
            indicatorView.alpha = 0
        }) { result in
            maskView.removeFromSuperview()
            completion?(result)
        }
    }
}
