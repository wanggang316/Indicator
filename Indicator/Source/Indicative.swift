//
//  Indicative.swift
//  GYUIComponents
//
//  Created by gang wang on 2019/8/6.
//

import UIKit

/// Indicator view structure
/// | View
/// | -- IndicatorMaskView
/// | ---- IndicatorView

public protocol Indicative {
    var appearance: IndicatorView.Appearance { get }
    var indicatorView: IndicatorView { get }
    var maskStyle: IndicatorMaskStyle { get }
    var position: IndicatorPosition { get }
    var interactionType: IndicatorInteractionType { get }
    var transition: IndicatorTransition { get }
}

extension Indicative {
    
    var appearance: IndicatorView.Appearance {
        return IndicatorView.defaultAppearance
    }
    public var maskStyle: IndicatorMaskStyle {
        return .clear
    }
    public var position: IndicatorPosition {
        return .center(offset: nil)
    }
    public var interactionType: IndicatorInteractionType {
        return .blocked
    }
    public var transition: IndicatorTransition {
        return .curveEaseInOut
    }
}

extension Indicative {
    
    func maskView(for view: UIView) -> IndicatorMaskView {
        let maskView = IndicatorMaskView(frame: view.bounds,
                                         indicatorView: self.indicatorView,
                                         position: self.position,
                                         style: self.maskStyle,
                                         interactionType: self.interactionType)
        maskView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        maskView.backgroundColor = self.maskStyle.backgroundColor
        return maskView
    }
}

public typealias IndicatorOptions = [IndicatorOptionItem]

public enum IndicatorOptionItem {
    case appearance(IndicatorView.Appearance)
    case indicatorView(IndicatorView)
    case maskStyle(IndicatorMaskStyle)
    case position(IndicatorPosition)
    case interactionType(IndicatorInteractionType)
    case transition(IndicatorTransition)
}

public struct IndicatorObject: Indicative {
    public var appearance: IndicatorView.Appearance
    public var indicatorView: IndicatorView
    public var maskStyle: IndicatorMaskStyle
    public var position: IndicatorPosition
    public var interactionType: IndicatorInteractionType
    public var transition: IndicatorTransition
    
    init(_ indicator: Indicative) {
        self.appearance = indicator.appearance
        self.indicatorView = indicator.indicatorView
        self.maskStyle = indicator.maskStyle
        self.position = indicator.position
        self.interactionType = indicator.interactionType
        self.transition = indicator.transition
    }
}


public enum IndicatorPosition {
    case top(offset: CGPoint?)
    case center(offset: CGPoint?)
    case bottom(offset: CGPoint?)
    case custom(center: CGPoint)
}

public enum IndicatorInteractionType {
    case blocked
    case allow
}
