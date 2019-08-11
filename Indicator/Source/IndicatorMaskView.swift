//
//  IndicatorMaskView.swift
//  GYUIComponents
//
//  Created by gang wang on 2019/8/5.
//

import UIKit

public enum IndicatorMaskStyle {
    
    case clear
    case white
    case black
    
    var backgroundColor: UIColor {
        switch self {
        case .clear: return .clear
        case .white: return UIColor(white: 1, alpha: 0.2)
        case .black: return UIColor(white: 0, alpha: 0.2)
        }
    }
}

public class IndicatorMaskView: UIView {
    
    internal let indicatorView: IndicatorView
    internal let position: IndicatorPosition
    internal let style: IndicatorMaskStyle
    internal let interactionType: IndicatorInteractionType
    
    internal init(frame: CGRect, indicatorView: IndicatorView, position: IndicatorPosition, style: IndicatorMaskStyle, interactionType: IndicatorInteractionType) {
        
        self.indicatorView = indicatorView
        self.position = position
        self.style = style
        self.interactionType = interactionType
        super.init(frame: frame)
        
        backgroundColor = style.backgroundColor
        addSubview(indicatorView)
        
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        updateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        self.indicatorView = IndicatorView(frame: CGRect.zero, appearance: IndicatorView.defaultAppearance)
        self.position = IndicatorPosition.center(offset: nil)
        self.style = .clear
        self.interactionType = .allow
        super.init(coder: aDecoder)
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        
        var constraints: [NSLayoutConstraint] = []
        
        let width = NSLayoutConstraint(item: indicatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: indicatorView.frame.width)
        let height = NSLayoutConstraint(item: indicatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: indicatorView.frame.height)
        constraints.append(width)
        constraints.append(height)
        
        switch position {
        case .center(let offset):
            let offset = offset ?? CGPoint.zero
            
            let constraintX = NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: offset.x)
            let constraintY = NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: offset.y)
            constraints.append(constraintX)
            constraints.append(constraintY)
        case .top(let offset):
            let offset = offset ?? CGPoint.zero
            
            let constraintX = NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: offset.x)
            let constraintY = NSLayoutConstraint(item: indicatorView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: offset.y)
            constraints.append(constraintX)
            constraints.append(constraintY)
        case .bottom(let offset):
            let offset = offset ?? CGPoint.zero
            
            let constraintX = NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: offset.x)
            let constraintY = NSLayoutConstraint(item: indicatorView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: offset.y)
            constraints.append(constraintX)
            constraints.append(constraintY)
        case .custom(let center):
            let constraintX = NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: center.x)
            let constraintY = NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: center.y)
            constraints.append(constraintX)
            constraints.append(constraintY)
        }
       
        self.addConstraints(constraints)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(point, with: event)
        
        switch interactionType {
        case .allow:
            return view != self ? view : nil
        default:
            return view
        }
    }
}
