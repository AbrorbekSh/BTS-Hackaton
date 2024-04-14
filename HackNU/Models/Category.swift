import Foundation

public struct Category: Codable {
    let id: Int
    let name: String
    let image: String?
}

public struct CategoryResponse: Codable {
    let content: [Category]
    let totalPages: Int
    let totalElements: Int
}

struct OfferResponse: Codable {
    let id: Int
    let bankCard: BankCard
    let category: Category
    let percentage: Double
    let conditions: String
    let dateFrom: String
    let dateTo: String
}
