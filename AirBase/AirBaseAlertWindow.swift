//
//  AirBaseAlertWindow.swift
//  AirBase
//
//  Created by Sai Prasad on 25/06/24.
//

import UIKit

class AirBaseAlertWindow: AirBaseAlertViewController {
    var window: UIWindow?
    func show(viewCtrl: UIViewController?) {
        if #available(iOS 13.0, *), let windowScene = viewCtrl?.getScene() {
            self.window = AirBaseByPassWindow.init(windowScene: windowScene)
        } else {
            self.window = AirBaseByPassWindow.init()
        }
        
        self.window?.tintColor = UIColor(red: 7.0 / 255.0, green: 173.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
        self.window?.backgroundColor = .clear
        self.window?.windowLevel = UIWindow.Level.alert
        self.window?.rootViewController = self
        self.window?.isHidden = false
        self.window?.makeKeyAndVisible()
        self.alertBox.alpha = 1
        self.window?.alpha = 1
        
        self.alertBox.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.alertBox.layer.shadowOpacity = 0.6
        self.alertBox.layer.shadowRadius = 5
        self.alertBoxCenterYConstrait?.constant = +(self.alertBox.frame.size.height + 20)
        self.alertBox.updateConstraints()
        self.view.layoutIfNeeded()
        DispatchQueue.main.async{
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.alertBoxCenterYConstrait?.constant = -(self.view.frame.height * 0.13)
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
                self.toastClose()
        })
        }
    }
    
    func toastClose()
    {
        UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: {
            self.alertBoxCenterYConstrait?.constant = +(self.alertBox.frame.size.height + 20)
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: TimeInterval(0.2), animations: {
                self.window?.alpha = 0
                self.window?.isHidden = true
                self.dismiss(animated: false, completion: nil)
                self.window?.resignKey()
                self.window = nil
            })
        })
    }
}

class AirBaseAlertViewController: UIViewController, UIViewControllerAnimatedTransitioning {
    
    let alertBox = UIView()
    var alertBoxCenterYConstrait: NSLayoutConstraint?
    var messageLabel: UILabel?
    private var widthConstraint = NSLayoutConstraint()
    private var messageLabelwidthConstraint = NSLayoutConstraint()
    
    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        var layoutConstraints = [NSLayoutConstraint]()
        var yAxisAnchor: NSLayoutYAxisAnchor
        self.view.backgroundColor = .clear
        self.view.addSubview(alertBox)
        alertBox.translatesAutoresizingMaskIntoConstraints = false
        alertBox.backgroundColor = UIColor(red: 38.0 / 255.0, green: 42.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
        alertBox.layer.cornerRadius = 10
        self.alertBoxCenterYConstrait = alertBox.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(self.view.frame.height * 0.13))
        layoutConstraints.append(self.alertBoxCenterYConstrait!)
        self.widthConstraint = alertBox.widthAnchor.constraint(equalToConstant: 270)
        layoutConstraints.append(widthConstraint)
        layoutConstraints.append(alertBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        yAxisAnchor = alertBox.topAnchor
        
        messageLabel = UILabel()
        messageLabel?.text = message
        messageLabel?.font = UIFont.systemFont(ofSize: 16)
        messageLabel?.textColor = UIColor(red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
        messageLabel?.textColor = UIColor(white: 1.0, alpha: 1.0)
        messageLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageLabel?.numberOfLines = 0
        messageLabel?.textAlignment = NSTextAlignment.center
        alertBox.addSubview(messageLabel!)
        messageLabel?.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints.append(messageLabel!.centerXAnchor.constraint(equalTo: alertBox.centerXAnchor))
        messageLabelwidthConstraint = messageLabel!.widthAnchor.constraint(equalToConstant: 270 - 15 * 2)
        layoutConstraints.append(messageLabelwidthConstraint)
        layoutConstraints.append(messageLabel!.topAnchor.constraint(equalTo: yAxisAnchor, constant: 12))
        yAxisAnchor = messageLabel!.bottomAnchor
        
        layoutConstraints.append(alertBox.bottomAnchor.constraint(equalTo: yAxisAnchor, constant: 12))
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if let toVC = transitionContext.viewController(forKey: .to) as? AirBaseAlertViewController {

            let containerView = transitionContext.containerView
            containerView.addSubview(toVC.view)

            toVC.view.alpha = 0
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
                toVC.view.alpha = 1
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}


class AirBaseByPassWindow: UIWindow {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            return nil
    }
}
