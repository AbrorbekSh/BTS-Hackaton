//
//  BankCardTableViewCell.swift
//  HackNU
//
//  Created by Аброрбек on 13.04.2024.
//

import UIKit

final class BankCardTableViewCell: UITableViewCell {
    // The bank card view to be displayed in the cell
    let bankCardView = CardView(
        bankName: "Jusan",
        cardNumber: "4004 **** **** 2123",
        bonus: "5%",
        cardType: "Visa",
        type: .cell
    )
    
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
        contentView.addSubview(bankCardView)
        
        // Set up Auto Layout constraints for the bank card view
        bankCardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bankCardView.topAnchor.constraint(equalTo: backView.topAnchor),
            bankCardView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
            bankCardView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            bankCardView.trailingAnchor.constraint(equalTo: backView.trailingAnchor)
        ])
    }

    // Required initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Add the bank card view to the content view of the cell
        contentView.addSubview(bankCardView)
        
        // Set up Auto Layout constraints for the bank card view
        bankCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bankCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bankCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bankCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bankCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

