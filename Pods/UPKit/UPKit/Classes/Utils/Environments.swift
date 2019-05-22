

import Foundation

public protocol EnvironmentVar {
    var key: String { get }
    var defualtValue: Any { get }
}

public enum UPKitEnvironmentVar: String, EnvironmentVar {
    
    case networkingLoggingEnabled = "NetworkingLoggingEnabled"
    
    public var key: String {
        return self.rawValue
    }
    
    public var defualtValue: Any {
        switch self {
        case .networkingLoggingEnabled: return true
        }
    }
}

public class Environment {

    static private let vars: [String: AnyObject] = {
        
        var environments: [String: AnyObject]?
        
        if let path = Bundle.main.path(forResource: "Environments", ofType: "plist") {
            environments = NSDictionary(contentsOfFile: path) as? [String : AnyObject]
        }
        
        if let environments = environments {
            
            guard let currentEnvironment = Environment.currentEnvironment else {
                return environments.values.first as? [String: AnyObject] ?? [:]
            }
            
            if let vars = environments[currentEnvironment] as? [String: AnyObject] {
                return vars
            }
        }
        return [:]
    }()
    
    public static func string(forEnvVar envVar: EnvironmentVar) -> String {
        return (Environment.vars["\(envVar.key)"] as? String) ?? envVar.defualtValue as! String
    }
    
    public static func bool(forEnvVar envVar: EnvironmentVar) -> Bool {
        return (Environment.vars["\(envVar.key)"] as? Bool) ?? envVar.defualtValue as! Bool
    }
    
    public static var currentEnvironment: String? {
        
        if let infoDictionary = Bundle.main.infoDictionary, let envStr = infoDictionary["Environment"] as? String {
            return envStr
        } else {
            return nil
        }
    }
}
