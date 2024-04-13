import SwiftUI

struct AddCategoryView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * RegLogConstants.verticalSpacing) {
                
//                Text("Добавьте карту")
//                    .font(.largeTitle)
//                    .foregroundStyle(Color.white)
//                    .padding(.vertical)
                Spacer()
                TextField("Card ID",text: $email)
                    .modifier(TextFieldModifier())
                TextField("Название Банка",text: $email)
                    .modifier(TextFieldModifier())
                TextField("Тип карты",text: $email)
                    .modifier(TextFieldModifier())
                TextField("Номер карты",text: $email)
                    .modifier(TextFieldModifier())
                TextField("Срок Действия",text: $email)
                    .modifier(TextFieldModifier())
                TextField("Название Банка",text: $email)
                    .modifier(TextFieldModifier())
                
                Spacer()
                Button {
                    
                } label: {
                    Text("Добавить карту")
                        .modifier(ButtonModifier())
                }
                .padding(.vertical)
                

                
                
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
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
