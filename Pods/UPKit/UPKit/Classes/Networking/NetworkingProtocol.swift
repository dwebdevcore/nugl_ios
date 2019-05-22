
import UIKit

public protocol NetworkingProtocol: class {
    
}

public extension NetworkingProtocol where Self: UIViewController {
    
    public func handle(error: APIError?, askToRetry: Bool = false, retryBlock: (() -> ())? = nil) {
        
        guard let error = error else {
            return
        }

        if askToRetry {
            
            let errorAlert = UIAlertController(title: "Error", message: error.userMessage, preferredStyle: .alert)
            
            errorAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            errorAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) in
                
                retryBlock?()
            }))
            
            self.present(errorAlert, animated: true, completion: nil)
        } else {
            Utils.showAlert(withTitle: "Error", message: error.userMessage, fromViewController: self)
        }
    }
}
