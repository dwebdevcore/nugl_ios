
import Foundation
import ObjectMapper
import SwiftyJSON
import Alamofire

public typealias JSONDictionary = [String: Any]

public class APIClient {

    public static let shared = APIClient()
    
    private init() {
        
    }
    
    @discardableResult public func requestItem<T: Mappable, E: APIError>(request: APIRoute, responseKey: String? = "data", onCompletion :@escaping (_ result : T?, _ error: E?) -> ()) -> Request {
        
        
        return self.request(request: request) { (response: Any?, error: E?) -> Void in
            
            if let response = response {
                
                let json = JSON(response)
                var objecJSON: JSON?
                
                if let responseKey = responseKey {
                    objecJSON = json[responseKey]
                }else {
                    objecJSON = json
                }
                
                if let objecJSON = objecJSON {
                    let result = Mapper<T>().map(JSONObject: objecJSON.rawValue)
                    onCompletion(result, nil)
                }else {
                    onCompletion(nil, error)
                }
                
            }else {
                onCompletion(nil, error)
            }
        }
    }
    
    @discardableResult public func requestItems<T: Mappable, E: APIError>(request: APIRoute, responseKey: String? = "data", onCompletion :@escaping (_ result : [T]?, _ error: E?) -> ()) -> Request {
        
        return self.request(request: request) { (response: Any?, error: E?) -> Void in
            
            if let response = response {
                
                let json = JSON(response)
                var objectData: JSON?
                
                if let responseKey = responseKey {
                    objectData = json[responseKey]
                }else {
                    objectData = json
                }
                
                if let objectData = objectData {
                    let result = Mapper<T>().mapArray(JSONObject: objectData.rawValue)
                    onCompletion(result, nil)
                }else {
                    onCompletion(nil, error)
                }
                
            }else {
                onCompletion(nil, error)
            }
        }        
    }
    
     public func uploadFile(name: String, fileName: String, data: Data, mimeType: String, to request: APIRoute, uploadProgress: @escaping (_ progress: Double) -> (), onCompletion: @escaping (_ response: Any?, _ error: APIError?) -> ()) {
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in

                multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
            },
            to: request.urlRequest!.url!,
            method: request.method,
            headers: request.urlRequest!.allHTTPHeaderFields!,
            encodingCompletion: { encodingResult in
        
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress: Progress) in
                        
                        uploadProgress(progress.fractionCompleted)
                    }).responseJSON(completionHandler: { (response) in
                        
                        self.handle(response: response, onCompletion: onCompletion)
                    })
                    
                case .failure(let encodingError):
                    
                    if Environment.bool(forEnvVar: UPKitEnvironmentVar.networkingLoggingEnabled) {
                        print("Error uploading file = \((encodingError as NSError).localizedDescription)")
                    }
                    
                    onCompletion(nil, APIError(userMessage: "Error uploading file"))
                }
            }
        )
    }
    
    @discardableResult public func request<E: APIError>(request: APIRoute, onCompletion :@escaping (_ response: Any?, _ error: E?) -> ()) -> Request {
        
        return Alamofire.request(request).validate().responseJSON { response -> Void in
        
            self.handle(response: response, onCompletion: onCompletion)
        }
    }
        
    private func handle<E: APIError>(response: DataResponse<Any>, onCompletion :@escaping (_ response: Any?, _ error: E?) -> ()) {
        
        switch response.result {
            
        case .success(let value):
                        
            if Environment.bool(forEnvVar: UPKitEnvironmentVar.networkingLoggingEnabled) {
                print(value)
            }
            
            if let value = value as? [String: Any], let _ = value["error"] as? String {
                
                let error = Mapper<E>().map(JSONObject: value) ?? E()
                onCompletion(nil, error)
            }else {
                onCompletion(value, nil)
            }
            
        case .failure(let error as NSError):
            
            if error.code != NSURLErrorCancelled {
                
                if Environment.bool(forEnvVar: UPKitEnvironmentVar.networkingLoggingEnabled) {
                    print("Error Status Code = \(response.response?.statusCode ?? -1)")
                }
                
                let resultError: E = apiError(from: response)
                
                onCompletion(nil, resultError)
            }
        default:
            break
        }
    }
    
    private func apiError<E: APIError>(from response: DataResponse<Any>) -> E {
        
        if let data = response.data {
            
            let json = try? JSON(data: data)
            if let json = json {
                
                if Environment.bool(forEnvVar: UPKitEnvironmentVar.networkingLoggingEnabled) {
                    print("Error Response = \(json)")
                }
                let error = Mapper<E>().map(JSONObject: json.object) ?? E()
                error.code = response.response?.statusCode
                
                return error
                
            }else {
                
                if Environment.bool(forEnvVar: UPKitEnvironmentVar.networkingLoggingEnabled) {
                    print("Error Response = \(String(data: data, encoding: .utf8) ?? "No error response")")
                }
                return E()
            }
        }
        
        if Environment.bool(forEnvVar: UPKitEnvironmentVar.networkingLoggingEnabled) {
            print("Error Response = No error response")
        }
        
        return E()
    }
}
