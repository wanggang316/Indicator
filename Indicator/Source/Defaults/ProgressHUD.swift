//
//  ProgressHUD.swift
//  GYUIComponents
//
//  Created by gang wang on 2019/8/4.
//

import UIKit

public enum ProgressHUD {
    case loading
    case statefulLoading(String)
    case success(String)
    case error(String)
    case info(String)
    case text(String)
    case custom(IndicatorView)
}

extension ProgressHUD: Indicative {
    
    public var appearance: IndicatorView.Appearance {
        return .init(style: .dark, isBlur: true, transparent: false, cornerRadius: 6)
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
    
    public var indicatorView: IndicatorView {
        
        switch self {
        case .loading:
            let view = LoadingIndicatorView(appearance: appearance)
            return view
        case .statefulLoading(let title):
            let view = StatefulLoadingIndicatorView(message: title,  appearance: appearance)
            return view
        case .success(let title):
            IndicatorShape.tintColor = appearance.style.foregroundColor
            let view = InfoIndicatorView(message: title, image: IndicatorShape.imageOfCheckmark, appearance: appearance)
            return view
        case .error(let title):
            IndicatorShape.tintColor = appearance.style.foregroundColor
            let view = InfoIndicatorView(message: title, image: IndicatorShape.imageOfCross, appearance: appearance)
            return view
        case .info(let title):
            IndicatorShape.tintColor = appearance.style.foregroundColor
            let view = InfoIndicatorView(message: title, image: IndicatorShape.imageOfInfo, appearance: appearance)
            return view
        case .text(let title):
            let view = TextIndicatorView(message: title, appearance: appearance)
            return view
        case .custom(let view):
            return view
        }
    }
}

// MARK -

class IndicatorShape {
    enum Cache {
        static var checkmark: UIImage?
        static var cross: UIImage?
        static var info: UIImage?
    }
    
    enum ShapeType {
        case checkmark
        case cross
        case info
    }
    
    static var tintColor: UIColor = .white {
        didSet {
            Cache.checkmark = nil
            Cache.cross = nil
            Cache.info = nil
        }
    }
    
    class func draw(_ type: ShapeType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .checkmark:
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .cross:
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            tintColor.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            checkmarkShapePath.close()
            
            tintColor.setFill()
            checkmarkShapePath.fill()
        }
        
        tintColor.setStroke()
        checkmarkShapePath.stroke()
    }
    
    class var imageOfCheckmark: UIImage {
        if (Cache.checkmark != nil) {
            return Cache.checkmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        IndicatorShape.draw(.checkmark)
        
        Cache.checkmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.checkmark!
    }
    class var imageOfCross: UIImage {
        if (Cache.cross != nil) {
            return Cache.cross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        IndicatorShape.draw(.cross)
        
        Cache.cross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.cross!
    }
    class var imageOfInfo: UIImage {
        if (Cache.info != nil) {
            return Cache.info!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        IndicatorShape.draw(.info)
        
        Cache.info = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.info!
    }
}
