import Foundation

/// Ходит в сеть за юзером
public class NetworkManager {
    public init() {}
    
    public func registerUser(_ user: User, password: String) async -> Result<[String: Any]?, Error> {
        let data = toJSON([
            APIConstants.name: user.name,
            APIConstants.email: user.email,
            APIConstants.password: password
        ])
        
        if let jsonString = String(data: data!, encoding: .utf8) {
            print(jsonString)
        }
        
        var request = URLRequest(url: URL(string: APIConstants.baseURL + APIConstants.Handles.register.rawValue)!)
        request.httpMethod = APIConstants.RESTMethod.post.rawValue
        request.httpBody = data
        request.setValue(APIConstants.HeaderValues.json.rawValue, forHTTPHeaderField: APIConstants.HeaderFields.contentType.rawValue)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return .success(jsonObject)
            } else {
                return .failure(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode data to JSON dictionary")))
            }
        } catch {
            return .failure(error)
        }
    }
    
    public func fetchUser(email: String, password: String) async -> Result<User?, Error> {
        let data = toJSON([
            APIConstants.email: email,
            APIConstants.password: password
        ])
        
        if let jsonString = String(data: data!, encoding: .utf8) {
            print(jsonString)
        }
        
        var request = URLRequest(url: URL(string: APIConstants.baseURL + APIConstants.Handles.login.rawValue)!)
        request.httpMethod = APIConstants.RESTMethod.post.rawValue
        request.httpBody = data
        request.setValue(APIConstants.HeaderValues.json.rawValue, forHTTPHeaderField: APIConstants.HeaderFields.contentType.rawValue)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            print(String(decoding: data, as: UTF8.self))
            let user = try? decoder.decode(User.self, from: data)
            return Result.success(user)
        } catch {
            return Result.failure(error)
        }
    }
    
    public static let shared: NetworkManager = NetworkManager()
}
