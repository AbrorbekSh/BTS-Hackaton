import SwiftUI

public class BigViewModel: ObservableObject {
    @Published var userLoggedIn: Bool = false
    @Published var curUser: User = User()
}

