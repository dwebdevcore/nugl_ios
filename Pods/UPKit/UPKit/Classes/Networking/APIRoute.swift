

import Foundation
import Alamofire

public enum APIRouteSessionPolicy {
    case privateDomain , publicDomain
}

public protocol APIRoute: URLRequestConvertible {
    
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var sessionPolicy: APIRouteSessionPolicy { get }
    var apiVersion: String { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var osTypeHeaderKey: String? { get }
    var appVersionHeaderKey: String? { get }
    var accessTokenHeaderKey: String? { get }
    var accessToken: String? { get }
}

public extension APIRoute {
    
    var osTypeHeaderKey: String? {
        return nil
    }
    
    var appVersionHeaderKey: String? {
        return nil
    }
    
    var accessTokenHeaderKey: String? {
        return nil
    }
    
    public func encoded(path: String, parameters: [String: Any]) throws -> URLRequest {
        
        let url = NSURL(string: baseURL + apiVersion)!
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path)!)
        urlRequest.httpMethod = self.method.rawValue
        
        if sessionPolicy == .privateDomain {
        
            let accessTokenHeaderKey = self.accessTokenHeaderKey ?? "access_token"
        
            if let token = accessToken {
                urlRequest.setValue(token, forHTTPHeaderField: accessTokenHeaderKey)
            }
        }
        
        if let osTypeHeaderKey = osTypeHeaderKey {
            
            urlRequest.setValue("os", forHTTPHeaderField: osTypeHeaderKey)
        }
        
        if let appVersionHeaderKey = appVersionHeaderKey {
            
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
            urlRequest.setValue(appVersion, forHTTPHeaderField: appVersionHeaderKey)
        }
                
        if Environment.bool(forEnvVar: UPKitEnvironmentVar.networkingLoggingEnabled) {
            print("-----------------------------------------------")
            print(urlRequest.url!.absoluteString)
            print(parameters)
            print("-----------------------------------------------")
        }
        
        return try self.encoding.encode(urlRequest, with: parameters)
    }
}
