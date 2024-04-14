import SwiftUI

struct BankCardView: View {
    let bank: Bank
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(bank.name)
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
            Text(cardType.name)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 100, height: 60)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? ColorScheme.lemonYellow : Color.clear, lineWidth: 3)
                )
        }
        .padding(.horizontal)
    }
}
struct AddCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var specialEntries: [SpecialEntry] = []
    @State var email: String = ""
    @State var password: String = ""
    @State private var selectedBankId: Int?
    @State private var selectedBankType: Int?
    var viewModel: BigViewModel
    var banks: [Bank]
    init(banks: [Bank], viewModel: BigViewModel) {
        self.viewModel = viewModel
        self.banks = banks
    }
    @State var cardTypes: [BankCard] = []
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Выберите банк:")
                    .padding(.horizontal)
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(banks, id: \.id) { bank in
                        BankCardView(bank: bank, isSelected: selectedBankId == bank.id)
                            .onTapGesture {
                                Task {
                                    selectedBankId = bank.id
                                    await self.fetchBankCardTypes(bankId: selectedBankId!)
                                }
                            }
                    }
                }
                .padding()
                if !cardTypes.isEmpty {
                    Text("Выберите тип карты:")
                        .padding()
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
                
                if self.selectedBankType != nil {
                    specials
                }
                Button {
                    Task {
                        await addOffersAndCard()
                        presentationMode.wrappedValue.dismiss()
                        fetchCards()
                    }
                } label: {
                    Text("Добавить карту")
                        .modifier(ButtonModifier())
                }
                .opacity(self.selectedBankType == nil ? 0.7 : 1)
                .disabled(self.selectedBankType == nil)
                .padding(.vertical)
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            
        }
        .background(Color.black)
    }
    var specials: some View {
        VStack(alignment: .leading) {
            Text("Добавьте спец-предложения:")
                .padding()
            ForEach($specialEntries, id: \.id) { $entry in
                SpecialEntryView(entry: $entry, onDelete: {
                                removeSpecialEntry(entry)
                            }, categories: viewModel.categories)
                            .padding(.bottom)
            }
            Image(systemName: "plus")
                .resizable()
                .frame(width: 15, height: 15)
                .padding(.horizontal)
                .foregroundColor(ColorScheme.lemonYellow)
                .onTapGesture {
                    addNewSpecialEntry()
                }
        }
    }
    
    private func fetchCards() {
        Task {
            do {
                let fetchedCards = try await NetworkManager.shared.getCards(userId: self.viewModel.curUser.id)
                print("lool")
                print(fetchedCards)
                print("lool")
                DispatchQueue.main.async {
                    self.viewModel.cards = fetchedCards
                }
            } catch let error {
                print("Failed to fetch bank cards: \(error)")
            }
        }
    }
    func addOffersAndCard() async {
        let groupId = UUID()  // Assuming each set of offers could be grouped by this ID if necessary.
        for entry in specialEntries {
//            let categoryID = categoryId(forName: entry.categoryId) ?? 0
            let newOffer = NewOfferRequest(
                userId: viewModel.curUser.id,  // Assuming you have access to the user ID here.
                bankCardId: selectedBankType ?? 0,
                categoryId: entry.categoryId,  // Assuming `first` holds the category ID.
                percentage: Double(entry.percentage) ?? 0,  // Assuming `second` holds the percentage.
                conditions: "Только через QR",  // Modify if conditions vary per entry.
                dateFrom: "2025-03-10",  // Modify as needed.
                dateTo: "2025-03-10"  // Modify as needed.
            )
            do {
                let success = try await NetworkManager.shared.addNewOffer(offerData: newOffer)
                if success {
                    print("Offer successfully added for category \(entry.categoryId)")
                } else {
                    print("Failed to add offer for category \(entry.categoryId)")
                }
            } catch {
                print("Error occurred when adding offer for category \(entry.categoryId): \(error)")
            }
        }
        
        // Optionally, call addCard here if it should be part of the same process
        await addCard()
    }
    func categoryId(forName name: String) -> Int? {
        viewModel.categories.first { $0.name == name }?.id
    }

    func addCard() async {
        let request = CardAdditionRequest(
            userId: viewModel.curUser.id,
            bankCardId: selectedBankType ?? 0
        )
        do {
            let success = try await NetworkManager.shared.addBankCard(request)
            if success {
                print("Card added successfully")
                // Handle success, such as navigating away or updating the UI.
            } else {
                print("Failed to add card")
                // Handle failure, such as showing an error message.
            }
        } catch {
            print("Network request failed: \(error)")
            // Handle errors, such as showing an error message.
        }
    }

    func addNewSpecialEntry() {
        specialEntries.append(SpecialEntry(categoryId: 0, percentage: ""))
    }
    
    func removeSpecialEntry(_ entry: SpecialEntry) {
        specialEntries.removeAll { $0.id == entry.id }
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
    struct SpecialEntryView: View {
        @Binding var entry: SpecialEntry
        var onDelete: () -> Void
        var categories: [Category]
        var pickerColor = ColorScheme.lemonYellow
        
        var body: some View {
            HStack {
                Picker("Select Category", selection: $entry.categoryId) {
                    ForEach(categories, id: \.id) { category in
                        Text(category.name).tag(category.id)
                    }
                }
                .accentColor(pickerColor)
                .pickerStyle(MenuPickerStyle())

                TextField("Скидка %", text: $entry.percentage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 5)

                Button(action: onDelete) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct SpecialEntry: Identifiable, Hashable {
    var id = UUID()
        var categoryId: Int
        var percentage: String
}


struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddCardView(banks: [], viewModel: BigViewModel())
    }
}
