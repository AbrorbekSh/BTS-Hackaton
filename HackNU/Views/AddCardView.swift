import SwiftUI

struct BankCardView: View {
    let bank: Bank
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "eye.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? ColorScheme.lemonYellow : Color.clear, lineWidth: 3)
                )
            Text(bank.name)
                .font(.caption)
                .lineLimit(1)
        }
        .padding(.horizontal)
    }
}
struct AddCardView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State private var selectedBankId: Int?
    var banks: [Bank]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: geometry.size.height * RegLogConstants.verticalSpacing) {
                Text("Выберите банк:")
                    .padding()
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(banks, id: \.id) { bank in
                        BankCardView(bank: bank, isSelected: selectedBankId == bank.id)
                            .onTapGesture {
                                selectedBankId = bank.id
//                                fetchBankCardTypes(bankId: bank.id)
                            }
                    }
                }
                .padding()
                Text("Выберите тип карты:")
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
        .background(Color.black)
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddCardView(banks: [])
    }
}
