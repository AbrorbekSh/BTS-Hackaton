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

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
    }
}
