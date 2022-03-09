//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 12/02/22.
//

import UIKit

public final class ErrorView : UIView {
    @IBOutlet private var lable: UILabel!
    
    public var message: String? {
        get { return isVisible ? lable.text : nil }
        set { setMessageAnimated(newValue) }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        lable.text = nil
        alpha = 0
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
        lable.text = message
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    @IBAction func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.lable.text = nil }
            })
    }
}
