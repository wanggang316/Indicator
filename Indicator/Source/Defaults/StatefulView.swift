//
//  StatefulView.swift
//  GYUIComponents
//
//  Created by gang wang on 2019/8/8.
//

import UIKit

public enum StatefulView {
    case loading
    case empty(title: String, subtitle: String, image: UIImage)
    case error(title: String, subtitle: String)
}

extension StatefulView: Indicative {
    
    public var appearance: IndicatorView.Appearance {
        return IndicatorView.Appearance(style: .light, isBlur: false, transparent: false, cornerRadius: 0)
    }
    
    public var indicatorView: IndicatorView {
        switch self {
        case .loading:
            return LoadingIndicatorView(appearance: appearance)
        case .empty(let title, let subtitle, let image):
            return InfoIndicatorView(message: title, image: image, appearance: appearance)
        default:
            return LoadingIndicatorView(appearance: appearance)
        }
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
        return .none
    }
    
}
