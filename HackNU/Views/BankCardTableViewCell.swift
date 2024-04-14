//
//  BankCardTableViewCell.swift
//  HackNU
//
//  Created by Аброрбек on 13.04.2024.
//

import UIKit

final class BankCardTableViewCell: UITableViewCell {
    var card: BankCard? { 
        didSet {
            guard let card else { return }
            let cardView = CardView(
                bankName: card.name,
                cardNumber: generateRandomCardNumber(),
                bonus: "10%",
                cardType: "Visa",
                type: .cell
            )
            bankCardView = cardView
            bankCardView.removeFromSuperview()
            contentView.addSubview(bankCardView)
            
            // Set up Auto Layout constraints for the bank card view
            bankCardView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                bankCardView.topAnchor.constraint(equalTo: backView.topAnchor),
                bankCardView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
                bankCardView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
                bankCardView.trailingAnchor.constraint(equalTo: backView.trailingAnchor)
            ])
     }
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


    
    func changeGradient() {
        bankCardView.changeGradient()
    }
    // The bank card view to be displayed in the cell
    var bankCardView: CardView!
    
    func configureForprofile() {
        bankCardView.configureForProfile()
    }
    
    private let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .black
        
        return view
    }()
    
    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add the bank card view to the content view of the cell
        contentView.addSubview(backView)
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    // Required initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

