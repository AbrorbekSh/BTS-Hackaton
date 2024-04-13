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

extension NetworkManager {
    public func getCategories() async -> Result<[Category], Error> {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.Handles.categories.rawValue) else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(APIConstants.HeaderValues.json.rawValue, forHTTPHeaderField: APIConstants.HeaderFields.contentType.rawValue)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let response = try decoder.decode(CategoryResponse.self, from: data)
            return .success(response.content)
        } catch {
            return .failure(error)
        }
    }
}

extension NetworkManager {
    func getBanks() async -> Result<[Bank], Error> {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.Handles.banks.rawValue) else {  
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let response = try decoder.decode(BanksResponse.self, from: data)
            return .success(response.content)
        } catch {
            return .failure(error)
        }
    }
}

extension NetworkManager {
    func getBankCard(by bankId: Int) async -> Result<[BankCard], Error> {
        let url = URL(string: "http://172.20.10.2:8080/bank-cards?bankId=\(bankId)&page=0&size=20")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let bankCards = try JSONDecoder().decode(BankCardResponse.self, from: data)
            print(bankCards.content)
            return .success(bankCards.content)
        } catch {
            return .failure(error)
        }
    }
}

extension NetworkManager {
    func addBankCard(_ requestData: CardAdditionRequest) async throws -> Bool {
        guard let url = URL(string: "http://172.20.10.2:8080/user-cards") else {
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestData = toJSON([
            "userId": requestData.userId,
            "bankCardId": requestData.bankCardId
        ])
        request.httpBody = requestData
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return false
        }

        // You might want to decode the response if there's any specific data you need to check
        return true
    }
}

struct CardAdditionRequest: Codable {
    var userId: Int
    var bankCardId: Int
    var name: String?
    var cardNumber: String?
    var validUntil: String?
}


