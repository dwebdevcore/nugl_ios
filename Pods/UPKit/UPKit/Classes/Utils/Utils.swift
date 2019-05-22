
import UIKit

open class Utils {
    
    public static func showAlert(withTitle title: String, message: String, fromViewController viewController: UIViewController, actionTitle: String? = nil, onCompletion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction((UIAlertAction(title: actionTitle ?? "Ok", style: .default, handler: { (_) in
            onCompletion?()
        })))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public static func topViewController() -> UIViewController? {
                
        if var topViewController = UIApplication.shared.keyWindow?.rootViewController {
            
            while let presentedVC = topViewController.presentedViewController {
                topViewController = presentedVC
            }
            return topViewController
        }
        return nil
    }
    
    public static func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
}
