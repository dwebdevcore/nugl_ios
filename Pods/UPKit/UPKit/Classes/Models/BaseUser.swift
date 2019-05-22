
import ObjectMapper

open class BaseUser: Mappable {
    
    open var uid: String = ""
    open var firstName = ""
    open var lastName = ""
    open var email = ""
    open var avatarURL: URL?
    
    open var fullName: String {
        
        var result = firstName
        if result.isEmpty == false {
            result += " "
        }
        result += lastName
        
        return result
    }
    
    public init() {
        
    }
    
    public init(uid: String, firstName: String, lastName: String, email: String, avatarURL: URL?) {
        
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.avatarURL = avatarURL
    }
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        
        uid <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        avatarURL <- (map["avatar_url"], URLTransform(shouldEncodeURLString: true))
    }
}
