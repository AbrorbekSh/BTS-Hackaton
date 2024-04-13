import SwiftUI
import RegexBuilder
import Combine

struct RegistrationView: View {
    @EnvironmentObject var viewModel: BigViewModel
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var passwordVerification: String = ""
    @State var passwordMismatch: Bool = false
    @State private var isShowingLogin = false
    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: geometry.size.height * RegLogConstants.verticalSpacing) {
                    //                HStack {
                    //                    Spacer()
                    //                    Button {
                    //
                    //                    } label: {
                    //                        Image(systemName: "xmark")
                    //                            .foregroundStyle(Color.gray)
                    //                    }
                    //                }
                    Image(systemName: "lasso")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: geometry.size.width * RegLogConstants.logoSize,
                            height: geometry.size.height * RegLogConstants.logoSize
                        )
                        .padding(.vertical, geometry.size.height * RegLogConstants.logoVerticalPadding)
                        .foregroundColor(ColorScheme.lemonYellow)
                    NavigationLink(destination: MainViewControllerRepresentable(viewModel: viewModel), isActive: $shouldNavigate) {
                        EmptyView()
                    }
                    VStack {
                        TextField("Email",text: $email)
                            .modifier(TextFieldModifier())
                        TextField("Имя",text: $username)
                            .modifier(TextFieldModifier())
                        CustomSecureField(placeholder: "Пароль", rightView: "eye.slash", text: $password)
                            .modifier(TextFieldModifier())
                        CustomSecureField(
                            placeholder: "Повторите пароль",
                            rightView: "eye.slash",
                            text: $passwordVerification
                        )
                        .modifier(TextFieldModifier())
                        .onReceive(Just(passwordVerification)) { _ in
                            passwordMismatch = password != passwordVerification
                        }
                    }
                    Text(passwordMismatch ? "Пароли разные" : "")
                        .font(Font.custom("", size: GlobalConstants.fontSize))
                        .foregroundColor(.red)
                    Button(action: {
                        registerUser()
                        fetchBanks()
                    }, label: {
                        Text("Зарегистрироваться")
                            .modifier(ButtonModifier())
                            .opacity(passwordMismatch ? RegLogConstants.disabledOpacity : RegLogConstants.enabledOpacity)
                    }
                    )
                    .disabled(passwordMismatch)
                    
                    
                    Spacer()
                    Divider()
                    HStack {
                        Text("Уже есть аккаунт?")
                            .font(Font.custom("", size: GlobalConstants.fontSize))
                        
                        
                        NavigationLink("Залогинься!", isActive: $isShowingLogin) {
                            LoginView(isShowing: $isShowingLogin)
                            
                        }
                        .font(Font.custom("", size: GlobalConstants.fontSize))
                        
                    }
                    .foregroundColor(Color(uiColor: .systemGray3))
                    .font(.footnote)
                    .padding(.bottom, geometry.size.height * RegLogConstants.bottomViewBottomPadding)
                    .padding(.top, geometry.size.height * RegLogConstants.bottomViewTopPadding)
                }
                .padding(.horizontal)
            }
        }
    }
    private func registerUser() {
        Task {
            let result = await NetworkManager.shared.registerUser(User(name: self.username,email: self.email), password: self.password)
            switch result {
            case .success(let data):
                guard let data = data else {return}
                if data["id"] == nil {
                    return
                }
                self.viewModel.userLoggedIn = true
                self.viewModel.curUser = User(id: data["id"] as! Int, name: data["name"] as! String, email: data[
                    "email"] as! String)
                self.shouldNavigate = true
                
            case .failure(let error):
                print("Login error: \(error)")
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

extension RegistrationView {
    public func fetchBanks() {
        Task {
            let result = await NetworkManager.shared.getBanks()
            switch result {
            case .success(let banks):
                DispatchQueue.main.async {
                    self.viewModel.banks = banks  // Assuming viewModel has a banks property to store the fetched banks
                }
            case .failure(let error):
                print("Error fetching banks: \(error)")
            }
        }
    }
}
