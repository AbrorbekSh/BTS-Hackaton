import UIKit
import SwiftUI

final class MainViewController: UIViewController, UITextFieldDelegate {
    private var categories: [Category] = []
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        collection.backgroundColor = .black
        collection.alwaysBounceVertical = true
        
        return collection
    }()
    
    private let blackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .black
        
        return view
    }()
    
    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить карту", for: .normal)
        button.backgroundColor = UIColor(ColorScheme.lemonYellow)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        button.addTarget(self, action: #selector(addCardButtonPressed), for: .touchUpInside)
        return button
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
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let systemImageName = "text.justify"
        
        // Get the system image
        if let systemImage = UIImage(systemName: systemImageName) {
            // Resize the image
            let newSize = CGSize(width: 30, height: 30) // Adjust these values to change the size
            let resizedImage = systemImage.resized(to: newSize)
            
            // Set the resized image to the button
            button.setImage(resizedImage, for: .normal)
        }
        
        button.tintColor = .white
        button.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
        view.backgroundColor = .black
        view.addSubview(searchTextField)
        view.addSubview(button)
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        view.addSubview(categoriesCollectionView)
        view.addSubview(addCardButton)
        
        searchTextField.addTarget(self, action: #selector(filterData), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(openReccomendations), for: .editingDidBegin)
        
        setUpConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(blackView)
        NSLayoutConstraint.activate([
            blackView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            blackView.widthAnchor.constraint(equalToConstant: 50),
            blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20),
            blackView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func showProfile() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    @objc private func filterData(_ sender: UITextField){
        
    }
    
    @objc private func openReccomendations(){
        
    }
    
    private func fetchCategories() {
        Task {
            let result = await NetworkManager.shared.getCategories()
            switch result {
            case .success(let fetchedCategories):
                DispatchQueue.main.async {
                    self.categories = fetchedCategories
                    self.categoriesCollectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch categories: \(error)")
            }
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCardButton.heightAnchor.constraint(equalToConstant: 50),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Combine current text with new text
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        categoriesCollectionView.reloadData()
        
        return true
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        cell.configure(with: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(CategoryViewController(), animated: true)
//        present(CategoryViewController(), animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2-30, height: 90)
    }
    
}

struct MainViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainViewController {
        let vc = MainViewController()
        vc.navigationItem.hidesBackButton = true
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
    }
}

extension MainViewController {
    @objc func addCardButtonPressed() {
        let addCardVC = UIHostingController(rootView: AddCardView())
        self.present(addCardVC, animated: true, completion: nil)
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
