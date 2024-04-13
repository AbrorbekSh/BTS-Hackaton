import Foundation

struct Bank: Codable {
    let id: Int
    let name: String
    let image: String?
}

struct BankCard: Codable {
    let id: Int
    let bank: Bank
    let name: String
    let image: String
    let comment: String?
}

struct BankCardResponse: Codable {
    let content: [BankCard]
    let totalPages: Int
    let totalElements: Int
}

struct BanksResponse: Codable {
    let content: [Bank]
    let totalPages: Int
    let totalElements: Int
}
