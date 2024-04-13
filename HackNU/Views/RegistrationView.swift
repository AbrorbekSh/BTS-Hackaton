import SwiftUI
import RegexBuilder
import Combine

struct RegistrationView: View {
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var passwordVerification: String = ""
    @State var passwordMismatch: Bool = false
    @State private var isShowingLogin = false
    
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
                    NavigationLink(destination: {
                        MainViewControllerRepresentable()
                            .background(Color.black)
                    }, label: {
                                    Text("Войти")
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
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
