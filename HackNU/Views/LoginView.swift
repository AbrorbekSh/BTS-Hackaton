import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @Binding var isShowing: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * RegLogConstants.verticalSpacing) {
                HStack {
                    Spacer()
//                    Button {
//
//                    } label: {
//                        Image(systemName: "xmark")
//                            .foregroundStyle(.gray)
//                    }
                }
                Image(systemName:"lasso")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: geometry.size.width * RegLogConstants.logoSize,
                        height: geometry.size.height * RegLogConstants.logoSize
                    )
                    .padding(.vertical, geometry.size.height * RegLogConstants.logoVerticalPadding)
                    .foregroundColor(ColorScheme.lemonYellow)
                TextField("Email",text: $email)
                    .modifier(TextFieldModifier())
                CustomSecureField(placeholder: "Пароль", rightView: "eye.slash", text: $password)
                    .modifier(TextFieldModifier())
                
                NavigationLink(destination: {
                    MainViewControllerRepresentable()
                        .background(Color.black)
                }, label: {
                                Text("Войти")
                    .modifier(ButtonModifier())
                              }
                    )
                
//                Button {
//                } label: {
//                    Text("Forgot your password?")
//                        .font(Font.custom("", size: GlobalConstants.fontSize))
//                        .font(.footnote)
//                        .foregroundColor(Color(uiColor: .systemGray4))
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .padding(.top, geometry.size.height * RegLogConstants.bottomViewBottomPadding)
//                }

                
                Spacer()
                Divider()
                HStack {
                    Text("Нет аккаунта?")
                        .font(Font.custom("", size: GlobalConstants.fontSize))
                        .foregroundColor(Color(uiColor: .systemGray3))
                    Button {
                        isShowing = false
                        } label: {
                        Text("Зарегистрируйся")
                            .font(Font.custom("", size: GlobalConstants.fontSize))
                            .foregroundColor(Color(uiColor: .systemGray3))
                    }
                }
                .font(.footnote)
                .padding(.bottom, geometry.size.height * RegLogConstants.bottomViewBottomPadding)
                .padding(.top, geometry.size.height * RegLogConstants.bottomViewTopPadding)
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isShowing: .constant(true))
    }
}

struct RegLogConstants {
    static let logoVerticalPadding = 0.07
    static let verticalSpacing = 0.015
    static let bottomViewBottomPadding = 0.01
    static let bottomViewTopPadding = 0.005
    static let logoSize = 0.2
    static let buttonHeight: CGFloat = 50
    static let disabledOpacity: Double = 0.7
    static let enabledOpacity: Double = 1
}
