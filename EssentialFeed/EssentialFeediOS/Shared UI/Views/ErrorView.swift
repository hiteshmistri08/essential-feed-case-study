//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 12/02/22.
//

import UIKit

public final class ErrorView : UIButton  {
    
    public var message: String? {
        get { return isVisible ? title(for: .normal) : nil }
        set { setMessageAnimated(newValue) }
    }
    
    public var onHide: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func configure() {
        backgroundColor = .errorBackgroundColor
        
        addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)
        configureLabel()
        hideMessage()
    }
    
    private func configureLabel() {
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        titleLabel?.font = .preferredFont(forTextStyle: .body)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        hideMessage()
    }
    
    public override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        let insectWidth = (self.configuration?.contentInsets.leading ?? 0) + (self.configuration?.contentInsets.trailing ?? 0)
        let insectHeight = (self.configuration?.contentInsets.top ?? 8) + (self.configuration?.contentInsets.bottom ?? 8)
        let desiredButtonSize = CGSize(width: labelSize.width + insectWidth, height: labelSize.height + insectHeight)
        return desiredButtonSize
    }
    
    private var isVisible: Bool {
        return alpha > 0
    }
    
    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }
    
    func showAnimated(_ message: String?) {
        setTitle(message, for: .normal)
        self.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    @IBAction func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.hideMessage() }
            })
    }
    
    private func hideMessage() {
        setTitle(nil, for: .normal)
        alpha = 0
        self.configuration?.contentInsets = NSDirectionalEdgeInsets(top: -2.5, leading: 0, bottom: -2.5, trailing: 0)
        onHide?()
    }
}

extension UIColor {
     static var errorBackgroundColor: UIColor {
         UIColor(red: 0.99951404330000004, green: 0.41759261489999999, blue: 0.4154433012, alpha: 1)
     }
 }
