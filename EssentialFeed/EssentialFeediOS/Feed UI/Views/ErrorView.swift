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
        get { return lable.text }
        set { lable.text = newValue }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        lable.text = nil
    }
}
