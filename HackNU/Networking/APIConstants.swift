struct APIConstants {
    public static let baseURL: String = "http://172.20.10.4:8080"
    static let id: String = "id"
    static let email: String = "email"
    static let name: String = "name"
    static let password: String = "password"
    
    enum Handles: String {
        case register = "/app-users/register"
        case login = "/app-users/login"
        case newEvent = "/newEvent"
        case users = "/users"
        case user = "/user"
        case events = "/events"
        case categories = "/categories?page=0&size=20"
    }
    
    enum RESTMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum HeaderFields: String {
        case contentType = "Content-Type"
    }
    
    enum HeaderValues: String {
        case json = "application/json"
    }
}
