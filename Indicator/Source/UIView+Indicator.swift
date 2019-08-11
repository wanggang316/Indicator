//
//  UIView+Indicator.swift
//  GYUIComponents
//
//  Created by gang on 2019/8/6.
//

import UIKit

fileprivate func getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

fileprivate func setRetainedAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

class Box<T> {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
}

private var indicatorKey: Void?

extension UIView {
    public internal(set) var _indicator: Indicative? {
        get {
            let box: Box<Indicative>? = getAssociatedObject(self, &indicatorKey)
            return box?.value
        }
        set {
            setRetainedAssociatedObject(self, &indicatorKey, newValue.map(Box.init))
        }
    }
    
    var indicatorMaskViews: [IndicatorMaskView] {
        return self.subviews.compactMap { subview -> IndicatorMaskView? in
            return subview as? IndicatorMaskView
        }
    }
}
