//
//  IndicatorView.swift
//  GYUIComponents
//
//  Created by wanggang on 28/12/2016.
//  Copyright © 2016 ZBJ. All rights reserved.
//

import UIKit

public protocol IndicatorViewType: class {
    var appearance: IndicatorView.Appearance { get set }
    
    func startAnimation()
    func stopAnimation()
}

extension IndicatorViewType {
    public func startAnimation() {}
    public func stopAnimation() {}
}

public class IndicatorView: UIView, IndicatorViewType {
    
    public enum Style {
        
        case light
        case dark
        case custom(foregroundColor: UIColor, backgroundColor: UIColor)
        
        var backgroundColor: UIColor {
            switch self {
            case .light: return .white
            case .dark: return UIColor(white: 0, alpha: 0.7)
            case .custom(_, let backgroundColor): return backgroundColor
            }
        }
        
        var foregroundColor: UIColor {
            switch self {
            case .light: return .black
            case .dark: return .white
            case .custom(let foregroundColor, _): return foregroundColor
            }
        }
        
        var effectSyle: UIBlurEffect.Style {
            switch self {
            case .light: return .extraLight
            default: return .dark
            }
        }
    }

    public struct Appearance {
        
        var style: Style = .dark
        var transparent: Bool = false
        var cornerRadius: CGFloat = 6
        var contentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        var isBlur: Bool = true
        
        init(style: Style = .dark,
             isBlur: Bool = true,
             transparent: Bool = true,
             cornerRadius: CGFloat = 6,
             contentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) {
            self.style = style
            self.isBlur = isBlur
            self.transparent = transparent
            self.cornerRadius = cornerRadius
            self.contentInset = contentInset
        }
    }
    
    public static let defaultAppearance = Appearance()
    public var appearance: Appearance = defaultAppearance
    
    public required init(frame: CGRect, appearance: Appearance) {
        
        super.init(frame: frame)
        
        self.appearance = appearance
        
        if !appearance.transparent {
            if appearance.isBlur {
                backgroundColor = .clear
                let effect = UIBlurEffect(style: appearance.style.effectSyle)
                let effectView = UIVisualEffectView(effect: effect)
                effectView.frame = bounds
                effectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                insertSubview(effectView, at: 0)
           } else {
               backgroundColor = appearance.style.backgroundColor
           }
       } else {
           backgroundColor = .clear
       }
       self.layer.cornerRadius = appearance.cornerRadius
       self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

public class LoadingIndicatorView: IndicatorView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    convenience init(appearance: Appearance) {
        
        self.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 70, height: 70)), appearance: appearance)
        
        activityIndicatorView.color = appearance.style.foregroundColor
        activityIndicatorView.center = self.center
        activityIndicatorView.startAnimating()
        addSubview(activityIndicatorView)
    }
    
    public required init(frame: CGRect, appearance: Appearance) {
        super.init(frame: frame, appearance: appearance)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func startAnimation() {
        activityIndicatorView.startAnimating()
    }
    
    public func stopAnimation() {
        activityIndicatorView.stopAnimating()
    }
}

public class StatefulLoadingIndicatorView: LoadingIndicatorView {
    
    // MARK: - Properties
    open var text: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    convenience init(message: String, appearance: Appearance) {
        
        self.init(frame: CGRect.zero, appearance: appearance)
        
        activityIndicatorView.color = appearance.style.foregroundColor
        activityIndicatorView.center = self.center
        activityIndicatorView.startAnimating()
        addSubview(activityIndicatorView)
        
        titleLabel.textColor = appearance.style.foregroundColor
        addSubview(self.titleLabel)
        
        self.titleLabel.text = message
        self.titleLabel.sizeToFit()
        
        let minWidth: CGFloat = 90
        let maxWidth: CGFloat = UIScreen.main.bounds.width / 2
        
        var width: CGFloat = minWidth
        if self.titleLabel.frame.width < minWidth {
            width = minWidth
        } else if self.titleLabel.frame.width > maxWidth {
            width = maxWidth
        } else {
            width = self.titleLabel.frame.width
        }
        
        self.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width + appearance.contentInset.left + appearance.contentInset.right, height: 90))
    }
    
    public required init(frame: CGRect, appearance: Appearance) {
        super.init(frame: frame, appearance: appearance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        self.activityIndicatorView.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 10)
        self.titleLabel.frame = CGRect(x: 10, y: self.activityIndicatorView.frame.maxY + 8, width: self.frame.width - 20, height: 16)
    }
}


public class InfoIndicatorView: IndicatorView {
    
    // MARK: - Properties
    open var text: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    
    @objc open dynamic var titleInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView;
    }()
    
    // MARK: -
    convenience init(message: String, image: UIImage, appearance: Appearance) {
        self.init(frame: CGRect.zero, appearance: appearance)
        
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        
        titleLabel.textColor = appearance.style.foregroundColor
        
        self.imageView.image = image
        self.titleLabel.text = message
        self.titleLabel.sizeToFit()
        
        self.layoutSubviews()
    }
    
    public required init(frame: CGRect, appearance: Appearance) {
        super.init(frame: frame, appearance: appearance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let minWidth: CGFloat = 90
        let maxWidth: CGFloat = UIScreen.main.bounds.width / 2
        
        var width: CGFloat = minWidth
        if self.titleLabel.frame.width < minWidth {
            width = minWidth
        } else if self.titleLabel.frame.width > maxWidth {
            width = maxWidth
            self.titleLabel.frame = CGRect(x: 10, y: self.imageView.frame.maxY + 8, width: width, height: self.titleLabel.frame.height)
            self.titleLabel.sizeToFit()
        } else {
            width = self.titleLabel.frame.width
        }

        self.frame.size = CGSize(width: width + 20, height: self.titleLabel.frame.height + 70)
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        self.imageView.center = CGPoint(x: self.frame.width / 2, y: 32)
        self.titleLabel.frame = CGRect(x: 10, y: self.imageView.frame.maxY + 8, width: width, height: self.titleLabel.frame.height)
    }
}

public class TextIndicatorView: IndicatorView {
    
    // MARK: - Properties
    open var text: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: -
    convenience init(message: String, appearance: Appearance) {
        self.init(frame: CGRect.zero, appearance: appearance)

        self.addSubview(self.titleLabel)
        
        titleLabel.textColor = appearance.style.foregroundColor
        
        self.titleLabel.text = message
        self.titleLabel.sizeToFit()
        
        let maxWidth = UIScreen.main.bounds.width - 60
        if self.titleLabel.frame.width > maxWidth {
            var titleFrame = self.titleLabel.frame
            titleFrame.size.width = maxWidth
            self.titleLabel.frame = titleFrame
            
            self.titleLabel.sizeToFit()
        }
        self.frame = CGRect(x: 0, y: 0, width: self.titleLabel.frame.width + 20 , height: self.titleLabel.frame.height + 30)
    }
    
    public required init(frame: CGRect, appearance: Appearance) {
        super.init(frame: frame, appearance: appearance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect(x: 10, y: 15, width: self.frame.width - 20, height: self.frame.height - 30)
    }
}
