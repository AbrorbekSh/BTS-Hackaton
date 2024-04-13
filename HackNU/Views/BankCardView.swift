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
    
    func configureForProfile() {
        bankNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        cardNumberLabel.font = UIFont.systemFont(ofSize: 12)
        bonusLabel.font = UIFont.boldSystemFont(ofSize: 14)
        cardTypeLabel.font = UIFont.systemFont(ofSize: 12)
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
    
    func changeGradinet() {
        gradientLayer?.colors = [
                                UIColor(hex: "#006C34").cgColor, UIColor(hex: "#DACE23").cgColor,]
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


