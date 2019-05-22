//
//  APIError.swift
//  Pods
//
//  Created by Diego Pais on 7/24/17.
//
//

import Foundation
import ObjectMapper

open class APIError: Mappable, Error {
    
    open var code: Int?
    open var userMessage = ""
    open var devMessage = ""
    
    required public init() {
        
    }
    
    public init(code: Int? = nil, userMessage: String?, devMessage: String? = nil) {
        
        self.code = code
        self.userMessage = userMessage ?? ""
        self.devMessage = devMessage ?? ""
    }
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        
        code <- map["error.error_code"]
        userMessage <- map["error.user_message"]
        devMessage <- map["error.dev_message"]
    }
}
