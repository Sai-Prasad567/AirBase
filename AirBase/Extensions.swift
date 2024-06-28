//
//  Extensions.swift
//  AirBase
//
//  Created by Sai Prasad on 22/06/24.
//

import Foundation
import UIKit

extension UIView {
    struct AnchoredConstraints {
        var top, leading, bottom, trailing, centerX, centerY, width, height: NSLayoutConstraint?
    }
    
    @discardableResult
    func addConstraint(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil, padding: UIEdgeInsets = .zero,
                       size: CGSize = .zero, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil,
                       centerXOffset: CGFloat = 0, centerYOffset: CGFloat = 0) -> AnchoredConstraints {
        self.translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 && width == nil {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        } else if let width = width {
            anchoredConstraints.width = widthAnchor.constraint(equalTo: width)
        }
        
        if size.height != 0 && height == nil {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        } else if let height = height {
            anchoredConstraints.height = heightAnchor.constraint(equalTo: height)
        }
        
        if let centerX = centerX {
            anchoredConstraints.centerX = centerXAnchor.constraint(equalTo: centerX, constant: centerXOffset)
        }
        
        if let centerY = centerY {
            anchoredConstraints.centerY = centerYAnchor.constraint(equalTo: centerY, constant: centerYOffset)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing,
         anchoredConstraints.width, anchoredConstraints.height,
         anchoredConstraints.centerX, anchoredConstraints.centerY].forEach{ $0?.isActive = true }
      
        return anchoredConstraints
    }
}


extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func getSizeOfatributedString(neededFont: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: neededFont]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }
}

class AirBaseTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 30)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class ZSAppearanceAssetColor: NSObject {
    
    public class func initNamed(name: String) -> UIColor! {
        if #available(iOS 11.0, *) {
            return UIColor.init(named: name, in: self.resourceBundle, compatibleWith: nil)
        } else {
            return UIColor.white
        }
    }
    
    private static let resourceBundle : Bundle = {
        guard let bundleUrl = Bundle.init(for: ZSAppearanceAssetColor.self).url(forResource: "AirBase", withExtension: "bundle") else {
            return Bundle.init(for: ZSAppearanceAssetColor.self)
        }
        guard let bundle = Bundle.init(url: bundleUrl) else {
            return Bundle.init(for: ZSAppearanceAssetColor.self)
        }
        return bundle
    }()
    
}


extension UIViewController {
    func showToast(controller: UIViewController, message: String, time: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 10
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            alert.dismiss(animated: true)
        }
    }
    
    public func getScene() -> UIWindowScene? {
        return self.getViewControllerWindowScene()?.windowScene
    }
    
    public func getViewControllerWindowScene() -> UIWindow? {
        var viewCtrl : UIViewController? = self
        while viewCtrl?.presentedViewController != nil {
            viewCtrl = viewCtrl?.presentedViewController
        }
        return viewCtrl?.navigationController?.visibleViewController?.view.window ?? viewCtrl?.view.window
    }
}
