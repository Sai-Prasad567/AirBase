//
//  AirBaseControllerUitilityExtension.swift
//  AirBase
//
//  Created by Sai Prasad on 24/06/24.
//

import Foundation
import UIKit

public class AirBasePopOverViewCtrl : UIViewController, UIPopoverPresentationControllerDelegate {
    public var cancel: (() -> ())?
    public var rightButtonTitle : String = ""//this block ll be added as target to the cancel button.it ll be added to close the popover in split screen
    public init(rightButTitle : String = "Cancel") {
        super.init(nibName: nil, bundle: nil)
        self.rightButtonTitle = rightButTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        if(self.navigationController != nil){
            self.navigationController?.preferredContentSize = self.preferredContentSize
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addOrRemoveCancelBut()
    }
       
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.addOrRemoveCancelBut()
    }
    
    func addOrRemoveCancelBut() {
        guard let window = self.getViewControllerWindow() else { return }
        if(cancel != nil && self.view.frame.size.width == window.frame.width){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: rightButtonTitle, style: UIBarButtonItem.Style.done, target: self, action:#selector(self.cancelButtonPressed) )
        }
        else{
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func cancelButtonPressed() {
        cancel!()
    }
    
    public func getViewControllerWindow() -> UIWindow? {
        var viewCtrl : UIViewController? = self
        while viewCtrl?.presentedViewController != nil {
            viewCtrl = viewCtrl?.presentedViewController
        }
        return viewCtrl?.navigationController?.visibleViewController?.view.window ?? viewCtrl?.view.window
    }
    
    public func showAspopOver(ctrl: UIViewController, sourceview: UIView, sourceRect: CGRect, contentSize: CGSize, title: String?, arrowDirection: UIPopoverArrowDirection?, completion: (() -> Void)?) {
        var ctrl = ctrl
        ctrl.title = title
        ctrl.preferredContentSize = CGSize(width: 375, height: 700)
        let bottomBorder = UIView()
        bottomBorder.tag = 12
        bottomBorder.backgroundColor =  UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0)
        bottomBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.5)
        ctrl.view.addSubview(bottomBorder)
        
        if(title != nil && title != ""){
            let nav = UINavigationController.init(rootViewController: ctrl)
            nav.navigationBar.isTranslucent = false
            nav.navigationBar.barTintColor = UIColor(white: 249.0 / 255.0, alpha: 1.0)
            nav.navigationBar.shadowImage = UIImage()
            
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(white: 249.0 / 255.0, alpha: 1.0)
//                /*appearance.shadowImage = ZSUIUtilities.imageWithColor(color:ZSAppearance.theme.color.seperatorLineW_seperatorLineD,rect:CGRect(x: 0, y: 0, wi*/dth: 0.5, height: 0.5))
                nav.navigationBar.standardAppearance = appearance
                nav.navigationBar.scrollEdgeAppearance = appearance
            } else {
                // Fallback on earlier versions
            }
            
            ctrl = nav
        }
        
        ctrl.modalPresentationStyle = UIModalPresentationStyle.popover
        ctrl.popoverPresentationController?.sourceView = sourceview
        ctrl.popoverPresentationController?.sourceRect = sourceRect
        ctrl.popoverPresentationController?.permittedArrowDirections = arrowDirection!
        if let pop = ctrl.popoverPresentationController {
            pop.delegate = self
        }
        ctrl.preferredContentSize = contentSize
        self.present(ctrl, animated: true, completion: completion)
    }
    
    public func pushViewControllerToTopViewController(viewController: UIViewController, title: String, size: CGSize?) {
        var viewCtrl = self as UIViewController
        while viewCtrl.presentedViewController != nil {
            viewCtrl = viewCtrl.presentedViewController!
        }
        (viewCtrl as? UINavigationController)?.pushViewController(viewController, animated: true)
        if(size != nil){
            viewController.preferredContentSize = size!
        }
    }
}

