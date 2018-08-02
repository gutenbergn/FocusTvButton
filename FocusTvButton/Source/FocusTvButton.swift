//
//  FocusTvButton.swift
//  FocusTvButton
//
//  Created by David Cordero on 01/09/16.
//  Copyright © 2016 David Cordero, Inc. All rights reserved.
//

import UIKit


@objc
open class FocusTvButton: UIButton {
    private let kInitialShadowOffset = CGSize(width: 0, height: 10)
    
    // MARK: - Public properties
    
    @objc
    @IBInspectable public var animationDuration: TimeInterval = 0.2 {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var cornerRadius: CGFloat = 5.0 {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var focusedBackgroundColor: UIColor = .red {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var focusedBackgroundEndColor: UIColor? {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var focusedScaleFactor: CGFloat = 1.2 {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var focusedShadowOpacity: Float = 0.25 {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var focusedShadowRadius: CGFloat = 10 {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var focusedTitleColor: UIColor = .white {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var gradientStartPoint: CGPoint = .zero {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var gradientEndPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var normalTitleColor: UIColor = .white {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var normalBackgroundColor: UIColor = .white {
        didSet { self.updateView() }
    }
    
    @objc
    @IBInspectable public var normalBackgroundEndColor: UIColor? {
        didSet { self.updateView() }
    }

    @objc
    @IBInspectable public var selectedBackgroundColor: UIColor = .black {
        didSet { self.updateView() }
    }

    @objc
    @IBInspectable public var selectedBackgroundEndColor: UIColor? {
        didSet { self.updateView() }
    }

    @objc
    @IBInspectable public var shadowColor: CGColor = UIColor.black.cgColor {
        didSet { self.updateView() }
    }

    @objc
    @IBInspectable public var shadowOffSetFocused: CGSize = CGSize(width: 0, height: 27) {
        didSet { self.updateView() }
    }
    
    public var shouldTintFocusedImage = true {
        didSet {
            self.updateFocusedImage()
        }
    }
    
    open override var isSelected: Bool {
        didSet { self.updateView() }
    }
    
    open override var buttonType: UIButtonType {
        return .custom
    }
    
    private var selectedGradientBackgroundColors: [CGColor] {
        let endColor = selectedBackgroundEndColor ?? selectedBackgroundColor
        return [selectedBackgroundColor.cgColor, endColor.cgColor]
    }
    
    private var focusedGradientBackgroundColors: [CGColor] {
        let endColor = focusedBackgroundEndColor ?? focusedBackgroundColor
        return [focusedBackgroundColor.cgColor, endColor.cgColor]
    }
    
    private var normalGradientBackgroundColors: [CGColor] {
        let endColor = normalBackgroundEndColor ?? normalBackgroundColor
        return [normalBackgroundColor.cgColor, endColor.cgColor]
    }
    
    private let gradientView = GradientView()
    
    // MARK: - Constructors
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateView()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.updateView()
        self.updateFocusedImage()
    }
    
    // MARK: - Focus Update
    
    override open func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            self.applyAnimatedFocusStyle()
        }, completion: nil)
    }
    
    // MARK: - Gesture Detection
    
    override open func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard presses.first?.type == .select else {
            return super.pressesBegan(presses, with: event)
        }
        
        UIView.animate(withDuration: self.animationDuration, animations: { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                self.transform = CGAffineTransform.identity
                self.layer.shadowOffset = self.kInitialShadowOffset
        })
    }
    
    override open func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard presses.first?.type == .select else {
            return super.pressesCancelled(presses, with: event)
        }
        
        guard self.isFocused else {
            return
        }
        
        UIView.animate( withDuration: self.animationDuration, animations: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
            self.layer.shadowOffset = self.shadowOffSetFocused
        })
    }
    
    override open func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard presses.first?.type == .select else {
            return super.pressesEnded(presses, with: event)
        }
        
        guard self.isFocused else {
            return
        }
        
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
            self.layer.shadowOffset = self.shadowOffSetFocused
        })
    }
    
    // MARK: - View Updates
    
    private func updateView() {
        self.setupGradientView()
        self.layer.cornerRadius = self.cornerRadius
        self.clipsToBounds = true
        self.setTitleColor(self.normalTitleColor, for: .normal)
        self.setTitleColor(self.focusedTitleColor, for: .focused)
        self.layer.shadowOpacity = self.focusedShadowOpacity
        self.layer.shadowRadius = self.focusedShadowRadius
        self.layer.shadowColor = self.shadowColor
        self.layer.shadowOffset = self.shadowOffSetFocused
        
        if self.isFocused {
            self.transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
        } else {
            self.transform = CGAffineTransform.identity
        }
    }
    
    private func setupGradientView() {
        self.gradientView.frame = bounds
        self.gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.gradientView.layer.cornerRadius = self.cornerRadius
        self.gradientView.startPoint = self.gradientStartPoint
        self.gradientView.endPoint = self.gradientEndPoint
        
        if self.isFocused {
            self.gradientView.colors = self.focusedGradientBackgroundColors
        } else if self.isSelected {
            self.gradientView.colors = self.selectedGradientBackgroundColors
        } else {
            self.gradientView.colors = self.normalGradientBackgroundColors
        }
        
        if let imageView = self.imageView {
            self.insertSubview(self.gradientView, belowSubview: imageView)
        } else if let titleLabel = self.titleLabel {
            self.insertSubview(self.gradientView, belowSubview: titleLabel)
        } else {
            self.addSubview(self.gradientView)
        }
    }
    
    private func applyAnimatedFocusStyle() {
        UIView.animate(withDuration: self.animationDuration, animations: { [weak self] in
            self?.updateView()
            }, completion: nil)
    }
    
    // MARK: - Image Setter
    
    override open func setImage(_ image: UIImage?, for state: UIControlState) {
        super.setImage(image, for: state)
        
        if state != .focused {
            self.updateFocusedImage()
        }
    }
    
    private func updateFocusedImage() {
        guard let normalImage = self.image(for: .normal), self.shouldTintFocusedImage else {
            self.setImage(self.image(for: .normal), for: .focused)
            return
        }
        
        self.setImage(normalImage.withRenderingMode(.alwaysTemplate), for: .focused)
    }
}

final private class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    fileprivate var colors: [Any]? {
        set {
            self.gradientLayer.colors = newValue
        }
        
        get {
            return self.gradientLayer.colors
        }
    }
    
    fileprivate var startPoint: CGPoint {
        set {
            self.gradientLayer.startPoint = newValue
        }
        
        get {
            return self.gradientLayer.startPoint
        }
    }
    
    fileprivate var endPoint: CGPoint {
        set {
            self.gradientLayer.endPoint = newValue
        }
        
        get {
            return self.gradientLayer.endPoint
        }
    }
    
    // MARK: - Private
    
    private lazy var gradientLayer: CAGradientLayer = {
        return self.layer as? CAGradientLayer ?? CAGradientLayer()
    }()
}
