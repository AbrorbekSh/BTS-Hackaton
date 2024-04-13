//
//  CategoryViewController.swift
//  HackNU
//
//  Created by Аброрбек on 13.04.2024.
//

import UIKit

final class CategoryViewController: UIViewController, UITextFieldDelegate {
    private let categories: [Category] = []
    
    
    private let placesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collection.backgroundColor = .white
        collection.alwaysBounceVertical = true
        
        return collection
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 24
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        
        textField.leftViewMode = .always
        
        let button = UIButton(frame: CGRect(x: 12, y: 12, width: 22, height: 24))
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
//        button.addTarget(MainViewController.self, action: #selector(mainButtonPressed), for: .touchUpInside)
        let containerImageView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        containerImageView.addSubview(button)
        textField.leftView = containerImageView
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(searchTextField)
        
        placesCollectionView.delegate = self
        placesCollectionView.dataSource = self
        view.addSubview(placesCollectionView)
        
        searchTextField.addTarget(self, action: #selector(filterData), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(openReccomendations), for: .editingDidBegin)
        
        setUpConstraints()
    }
    
    @objc private func filterData(_ sender: UITextField){

     }
     
     @objc private func openReccomendations(){

     }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            placesCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            placesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Combine current text with new text
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: string)

        placesCollectionView.reloadData()
        
        return true
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.categoryName.text = categories[indexPath.row].name

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Check if the kind is header
        if kind == UICollectionView.elementKindSectionHeader {
            // Dequeue a reusable header view
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath)
            
            // Configure your header view
            // For example, you can add a label to the header view
            let label = UILabel(frame: header.bounds)
            label.text = "Category name"  // Customize the title as desired
            label.textAlignment = .left
            label.font = UIFont.boldSystemFont(ofSize: 20)
            header.addSubview(label)
            
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Return the size of the header, e.g., width equal to collection view's width and height as desired
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3-24, height: 130)
    }
}


