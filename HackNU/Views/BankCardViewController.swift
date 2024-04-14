//
//  BankCardViewController.swift
//  HackNU
//
//  Created by Аброрбек on 13.04.2024.
//

import UIKit

final class BankCardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let viewModel: BigViewModel
    private let category: Int = 1
    // Create an instance of UITableView
    private let tableView = UITableView()
    private let bankCardView = CardView(
        bankName: "Jusan",
        cardNumber: "4004 **** **** 2123",
        bonus: "5%",
        cardType: "Visa",
        type: .main
    )
    
    private var cards:[BankCard] = [
        
    ] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(viewModel: BigViewModel) {
        self.viewModel = viewModel
        self.cards = viewModel.cards.map { BankCard(id: $0.bankCard.id, bank: $0.bankCard.bank, name: $0.bankCard.name, image: nil, comment: nil) }
        super.init(nibName: nil, bundle: nil)
        
        loadBanks()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let  titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Выгоднее всего:"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white

        return label
    }()
    
    // Data source for the table view
    private let cardData = [
        (bankName: "Bank A", cardNumber: "1234 5678 9012 3456", bonus: "Bonus: 100 points", cardType: "Visa"),
        (bankName: "Bank B", cardNumber: "9876 5432 1098 7654", bonus: "Bonus: 200 points", cardType: "Mastercard"),
        // Add more card data as needed
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the view
        setupView()
    }
    
    func generateRandomCardNumber() -> String {
        // Start with "4400"
        var cardNumber = "4400"
        
        // Add the masked section
        cardNumber += " **** **** "
        
        // Generate four random digits for the end
        let lastFourDigits = (0..<4).map { _ in Int.random(in: 0...9) }.map(String.init).joined()
        
        // Append the random digits to the card number
        cardNumber += lastFourDigits
        
        return "**** **** **** ****"
    }


    // Method to set up the view
    private func setupView() {
        // Set the background color of the view controller's view
        view.backgroundColor = .black

        // Customize the bank card view properties (optional)
        bankCardView.bankName = viewModel.bestCard!.name
        bankCardView.cardNumber = generateRandomCardNumber()
        bankCardView.bonus = "Кэшбэк: " + String(Int(viewModel.bonus)) + "%"
        bankCardView.cardType = "Visa"

        tableView.backgroundColor = .black
        // Add the bank card view to the view controller's view
        view.addSubview(bankCardView)
        view.addSubview(titleLabel)

        // Set up Auto Layout constraints for the bank card view
        bankCardView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            bankCardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            bankCardView.heightAnchor.constraint(equalToConstant: 170),
            bankCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bankCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Set up the table view
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register the custom cell
        tableView.register(BankCardTableViewCell.self, forCellReuseIdentifier: "BankCardCell")
        
        // Add the table view to the view controller's view
        view.addSubview(tableView)
        
        // Set up Auto Layout constraints for the table view
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: bankCardView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }

    // UITableViewDataSource method to define the number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count - 1
    }

    // UITableViewDataSource method to configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCardCell", for: indexPath) as! BankCardTableViewCell
        
        // Get the card data for the current row
        let card = cards[indexPath.row + 1]
        cell.card = card
        
        // Configure the bank card view in the cell
        cell.bankCardView.bankName = card.bank.name
        cell.bankCardView.cardNumber = generateRandomCardNumber()
        cell.bankCardView.bonus = "Кэшбэк: " + randomLess(by: Int(viewModel.bonus) - 1) + "%"
        cell.bankCardView.cardType = card.name
        
        cell.changeGradient()
        
        return cell
    }
    
    func randomLess(by: Int) -> String {
        return String(Int.random(in: 0...by))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension BankCardViewController {
    func loadBanks() {
            Task {
                let result = await NetworkManager.shared.getBankCard(by: category)
                switch result {
                case .success(let cards):
                    DispatchQueue.main.async {
                        // Assuming your view model has a `banks` property
//                        self.cards = cards
                    }
                case .failure(let error):
                    print("Failed to fetch banks: \(error)")
                }
            }
        }
}
