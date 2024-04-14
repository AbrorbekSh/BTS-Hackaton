//
//  BankCardView.swift
//  HackNU
//
//  Created by Аброрбек on 13.04.2024.
//

import UIKit
import QuartzCore

final class CardView: UIView {
    // Properties to hold the card information
    private let type: ViewType
    private var gradientLayer: CAGradientLayer?
    
    enum ViewType {
        case cell
        case main
    }

    init(card: BankCard, type: ViewType = .cell) {
            self.bankName = card.bank.name
            self.cardType = card.name
            self.type = type
            super.init(frame: .zero) // Ensure super.init is called here
            setupView()
            setupGradient()
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
            bonusLabel.text = bonus
        }
    }
    var cardType: String = "Visa" {
        didSet {
            cardTypeLabel.text = cardType
        }
    }
    
    func configureForProfile() {
        bankNameLabel.text = bankName
        bankNameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        cardNumberLabel.font = UIFont.systemFont(ofSize: 16)
        bonusLabel.font = UIFont.boldSystemFont(ofSize: 0)
        cardTypeLabel.font = UIFont.systemFont(ofSize: 16)
        cardTypeLabel.text = cardType
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
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
    
    // Setup the custom view
    private func setupView() {
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
    
    func changeGradient() {
        // Define the colors
        let gold = UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1) // RGB for gold
        let silver = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1) // RGB for silver
        let black = UIColor.systemBlue // Shortcut for black
        let blue = UIColor.black

        // Array of colors
        let colors = [gold.cgColor, silver.cgColor, black.cgColor]

        // Randomly select two different colors from the array
        var selectedColors = Set<CGColor>()
        while selectedColors.count < 2 {
            if let randomColor = colors.randomElement() {
                selectedColors.insert(randomColor)
            }
        }

        // Assign random colors to gradient
        gradientLayer?.colors = Array(selectedColors)
    }

    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 15
        gradientLayer.colors = [UIColor(hex: "#009245").cgColor,
                                UIColor(hex: "#FCEE21").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
        
        self.gradientLayer = gradientLayer
    }
}

extension UIColor {
    // Initialize UIColor from hex code
    convenience init(hex: String) {
        // Remove any hash prefix
        let hexCode = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        // Convert hex code to a valid 8-character code (RRGGBBAA)
        let expandedHex: String
        if hexCode.count == 3 { // RGB (e.g., #ABC)
            expandedHex = hexCode.map { "\($0)\($0)" }.joined() + "FF"
        } else if hexCode.count == 4 { // RGBA (e.g., #ABCF)
            expandedHex = hexCode.map { "\($0)\($0)" }.joined()
        } else if hexCode.count == 6 { // RRGGBB (e.g., #AABBCC)
            expandedHex = hexCode + "FF"
        } else {
            expandedHex = hexCode // RRGGBBAA (e.g., #AABBCCDD)
        }
        
        // Convert the hex code to RGBA values
        let scanner = Scanner(string: expandedHex)
        var hexNumber: UInt64 = 0
        
        scanner.scanHexInt64(&hexNumber)
        
        let red = CGFloat((hexNumber & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(hexNumber & 0x000000FF) / 255.0
        
        // Initialize UIColor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


