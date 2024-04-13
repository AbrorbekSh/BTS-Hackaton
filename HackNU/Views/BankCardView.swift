//
//  BankCardView.swift
//  HackNU
//
//  Created by Аброрбек on 13.04.2024.
//

import UIKit

final class CardView: UIView {
    // Properties to hold the card information
    private let type: ViewType
    
    enum ViewType {
        case cell
        case main
    }

    var bankName: String = "Bank Name" {
        didSet {
            bankNameLabel.text = bankName
        }
    }
    var cardNumber: String = "1234 5678 9012 3456" {
        didSet {
            cardNumberLabel.text = cardNumber
        }
    }
    var bonus: String = "Bonus: 100 points" {
        didSet {
            bonusLabel.text = "Кэшбэк: 10%"
        }
    }
    var cardType: String = "Visa" {
        didSet {
            cardTypeLabel.text = cardType
        }
    }

    // Labels for displaying the card information
    private let bankNameLabel = UILabel()
    private let cardNumberLabel = UILabel()
    private let bonusLabel = UILabel()
    private let cardTypeLabel = UILabel()

    init(bankName: String, cardNumber: String, bonus: String, cardType: String, type: ViewType) {
        self.bankName = bankName
        self.cardNumber = cardNumber
        self.bonus = bonus
        self.cardType = cardType
        self.type = type

        // Call the superclass initializer
        super.init(frame: .zero)

        // Set up the view
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup the custom view
    private func setupView() {
        // Set the background color for the card view
        self.backgroundColor = UIColor.lightGray
        layer.cornerRadius = 15
        
        switch type {
        case .cell:
            bankNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            cardNumberLabel.font = UIFont.systemFont(ofSize: 18)
            bonusLabel.font = UIFont.boldSystemFont(ofSize: 18)
            cardTypeLabel.font = UIFont.systemFont(ofSize: 14)
        case .main:
            bankNameLabel.font = UIFont.boldSystemFont(ofSize: 28)
            cardNumberLabel.font = UIFont.systemFont(ofSize: 24)
            bonusLabel.font = UIFont.boldSystemFont(ofSize: 24)
            cardTypeLabel.font = UIFont.systemFont(ofSize: 20)
        }
        
        // Configure labels
        bankNameLabel.text = bankName
        bankNameLabel.textColor = .white
        
        cardNumberLabel.text = cardNumber
        cardNumberLabel.textColor = .white
        
        bonusLabel.text = bonus
        bonusLabel.textColor = .white
        
        cardTypeLabel.text = cardType
        cardTypeLabel.textColor = .white
        
        // Add labels to the view
        addSubview(bankNameLabel)
        addSubview(cardNumberLabel)
        addSubview(bonusLabel)
        addSubview(cardTypeLabel)

        // Layout the labels using Auto Layout
        bankNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        bonusLabel.translatesAutoresizingMaskIntoConstraints = false
        cardTypeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Bank name label constraints
            bankNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            bankNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            // Card number label constraints
            cardNumberLabel.topAnchor.constraint(equalTo: bankNameLabel.bottomAnchor, constant: 10),
            cardNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            // Bonus label constraints
            bonusLabel.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 10),
            bonusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            // Card type label constraints
            cardTypeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            cardTypeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}

