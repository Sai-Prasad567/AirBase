//
//  AirBaseCheckButton.swift
//  AirBase
//
//  Created by Sai Prasad on 24/06/24.
//

import Foundation
import UIKit

class AirBaseCheckButton: UIButton {
    public var shouldHighlightSubviews : Bool = false;
    override var isHighlighted: Bool{
        didSet{
            if !shouldHighlightSubviews {
                if isHighlighted {
                    self.alpha = 0.3
                }
                else{
                    self.alpha = 1
                }
            } else {
                if isHighlighted {
                    for subview in self.subviews {
                        subview.alpha = 0.5
                    }
                } else {
                    for subview in self.subviews {
                        subview.alpha = 1.0
                    }
                }
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear;
        self.adjustsImageWhenHighlighted = false;
        self.setImage(UIImage(named: "Checkboxfilled"), for: .selected)
        self.setImage(UIImage(named: "Checkboxempty"), for: .normal)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width = contentSize.width+titleEdgeInsets.left+titleEdgeInsets.right
        return contentSize;
    }
}
