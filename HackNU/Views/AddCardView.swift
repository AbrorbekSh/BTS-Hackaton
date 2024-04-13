import SwiftUI

struct BankCardView: View {
    let bank: Bank
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "")
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

struct CardTypeView: View {
    let cardType: BankCard
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? ColorScheme.lemonYellow : Color.clear, lineWidth: 3)
                )
            Text(cardType.name)
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
    @State private var selectedBankType: Int?
    var banks: [Bank]
    @State var cardTypes: [BankCard] = []
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: geometry.size.height * RegLogConstants.verticalSpacing) {
                    Text("Выберите банк:")
                        .padding()
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(banks, id: \.id) { bank in
                            BankCardView(bank: bank, isSelected: selectedBankId == bank.id)
                                .onTapGesture {
                                    Task {
                                        selectedBankId = bank.id
                                        print(selectedBankId)
                                        await self.fetchBankCardTypes(bankId: selectedBankId!)
                                    }
                                }
                        }
                    }
                    .padding()
                    if !cardTypes.isEmpty {
                        Text("Выберите тип карты:")
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(cardTypes, id: \.id) { cardType in
                                CardTypeView(cardType: cardType, isSelected: selectedBankType == cardType.id)
                                    .onTapGesture {
                                        selectedBankType = cardType.id
                                    }
                            }
                        }
                        .padding()
                    }
//                    TextField("Номер карты",text: $email)
//                        .modifier(TextFieldModifier())
//
//                    TextField("Срок Действия",text: $email)
//                        .modifier(TextFieldModifier())
//                        
//                    TextField("Название Банка",text: $email)
//                        .modifier(TextFieldModifier())
                        
                    
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
        .background(Color.black)
    }
    func fetchBankCardTypes(bankId: Int) async {
            do {
                let result = await NetworkManager.shared.getBankCard(by: bankId)
                switch result {
                case .success(let cardTypes):
                    self.cardTypes = cardTypes
                case .failure:
                    self.cardTypes = []
                }
            } catch {
//                self.showError = true
            }
        }
    
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddCardView(banks: [])
    }
}
