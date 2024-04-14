import SwiftUI

public class BigViewModel: ObservableObject {
    @Published var userLoggedIn: Bool = false
    @Published var curUser: User = User()
    @Published var bestCard: BankCard?
    @Published var categories: [Category] = []
    @Published var banks: [Bank] = []
    @Published var cards: [BankCardDetails] = []
    @Published var bonus: Double = 0.0
}

