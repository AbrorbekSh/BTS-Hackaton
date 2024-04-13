import SwiftUI

public class BigViewModel: ObservableObject {
    @Published var userLoggedIn: Bool = false
    @Published var curUser: User = User()
    @Published var categories: [Category] = []
    @Published var banks: [Bank] = []
}

