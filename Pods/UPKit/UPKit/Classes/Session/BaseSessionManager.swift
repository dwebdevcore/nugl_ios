

import Foundation
import ObjectMapper
import SwiftyJSON
import KeychainAccess

open class BaseSessionManager<UserType: BaseUser> {
    
    public var accessToken: String? {
        
        if let accessToken = _accessToken {
            return accessToken
        }
        
        if let accessToken = keychain[accessTokenKey] , accessToken != "" {
            _accessToken = accessToken
            return accessToken
        }
        return nil
    }
    
    public var currentUser: UserType? {
        
        if self.accessToken != nil {
            return _currentUser
        }
        return nil
    }
    
    private let userKey: String = "user"
    private let accessTokenKey: String = "access_token"
    private let loggedInKey: String = "<6123><6267>"
    private let keychain: Keychain!

    private var _accessToken: String?
    private var _currentUser: UserType? {
        didSet {
            saveCurrentUser()
        }
    }
    
    public init() {
        
        self.keychain = Keychain(service: Bundle.main.bundleIdentifier!)
        
        NotificationCenter.default.addObserver(forName: Notification.Name.Session.invalidToken, object: nil, queue: OperationQueue.main) {[weak self] (_) in
            self?.logOut()
        }
        
        if UserDefaults.standard.bool(forKey: loggedInKey) {
            loadSavedUser()
        }else {
            logOut()
        }
    }

    open func saveAccessToken(token: String) {
        _accessToken = token
        UserDefaults.standard.set(true, forKey: loggedInKey)
        saveAccessTokenToKeyChain()
    }
    
    open func setCurrentUser(user: UserType) {
        _currentUser = user
    }
    
    open func logOut() {
        self.deleteAccessToken()
        UserDefaults.standard.set(false, forKey: loggedInKey)
        NotificationCenter.default.post(name: Notification.Name.Session.userDidSignOut, object: nil)
    }
    
    public func saveCurrentUser() {
        
        if let currentUser = self._currentUser {
            
            let jsonUser = Mapper().toJSONString(currentUser)
            if let userData = jsonUser?.data(using: .utf8, allowLossyConversion: true) {
                
                let userStr = userData.base64EncodedString()
                keychain[userKey] = userStr
            }
        }
    }
    
    private func saveAccessTokenToKeyChain() {
        self.keychain[accessTokenKey] = _accessToken ?? ""
    }
    
    private func deleteAccessToken() {
        try! self.keychain.remove(accessTokenKey)
        _accessToken = nil
    }
    
    private func loadSavedUser() {
        
        if let userBase64Str = keychain[userKey], let userData = Data(base64Encoded: userBase64Str) {

            let jsonUser = String(data: userData, encoding: .utf8)!
            self._currentUser = Mapper<UserType>().map(JSONString: jsonUser)
        }
    }
}
