import UIKit
import SwiftUI

final class MainViewController: UIViewController, UITextFieldDelegate {
    private let viewModel: BigViewModel
    private var categories: [Category] = [] {
        didSet {
            filteredCategories = categories
        }
    }
    private var filteredCategories: [Category] = [] 
    private var banks: [Bank] = []
    
    init(viewModel: BigViewModel, categories: [Category] = [], banks: [Bank] = []) {
        self.viewModel = viewModel
        self.categories = categories
        self.banks = banks
        super.init(nibName: nil, bundle: nil)
        
        searchTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить карту", for: .normal)
        button.backgroundColor = UIColor(ColorScheme.lemonYellow)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
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
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
        textField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        
        textField.leftViewMode = .always
        textField.textColor = .black
        
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
        fetchCards()
        self.navigationItem.hidesBackButton = true
        hideKeyboardWhenTappedAround()
        loadBanks()
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
    
    @objc private func showProfile() {
        let profileVC = ProfileViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: profileVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc private func filterData(_ sender: UITextField){
        
    }
    
    @objc private func openReccomendations(){
        
    }
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func fetchCategories() {
        Task {
            let result = await NetworkManager.shared.getCategories()
            switch result {
            case .success(let fetchedCategories):
                DispatchQueue.main.async {
                    self.viewModel.categories = fetchedCategories
                    self.categories = fetchedCategories
                    self.categoriesCollectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch categories: \(error)")
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
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
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
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Combine current text with new text
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        if updatedText.isEmpty {
            filteredCategories = categories
        } else {
            filteredCategories = categories.filter { category in
                category.name.localizedCaseInsensitiveContains(updatedText)
            }
        }
        categoriesCollectionView.reloadData()
        
        return true
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = filteredCategories[indexPath.row]
        cell.imageView.image = UIImage(named: filteredCategories[indexPath.row].name)
        cell.configure(with: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*activityIndicator.startAnimating() */ // Start loading animation

            // Perform the loading and API call asynchronously
            Task {
                // Wait for three seconds

                // Simultaneously, fetch the best offer
                do {
                    let bankCard = try await NetworkManager.shared.fetchBestOffer(userId: 3, categoryId: categories[indexPath.row].id)
                    
                    // Stop the activity indicator
                    DispatchQueue.main.async { [weak self] in
//                        self?.activityIndicator.stopAnimating()
                        
                        // Proceed to show the next view controller
                        self!.viewModel.bestCard = bankCard.0
                        self!.viewModel.bonus = bankCard.1
                        let vc = BankCardViewController(viewModel: self!.viewModel)
                        print("working card")
                        print(bankCard)
                        print("working card")
//                        vc.bankCard = bankCard  // Assuming you have a way to pass the bank card to the VC
                        let navController = UINavigationController(rootViewController: vc)
                        self?.present(navController, animated: true, completion: nil)
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        // Handle error, show alert or message
                        print("Error fetching offer: \(error)")
                    }
                }
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2-30, height: 90)
    }
    
    
}

extension MainViewController {
    func loadBanks() {
            Task {
                let result = await NetworkManager.shared.getBanks()
                switch result {
                case .success(let banks):
                    DispatchQueue.main.async {
                        // Assuming your view model has a `banks` property
                        self.banks = banks
                    }
                case .failure(let error):
                    print("Failed to fetch banks: \(error)")
                }
            }
        }
}

struct MainViewControllerRepresentable: UIViewControllerRepresentable {
    private let viewModel: BigViewModel
    
    init(viewModel: BigViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> MainViewController {
        let vc = MainViewController(viewModel: viewModel)
        vc.navigationItem.hidesBackButton = true
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
    }
}

extension MainViewController {
    @objc func addCardButtonPressed() {
        let addCardVC = UIHostingController(rootView: AddCardView(banks: banks, viewModel: viewModel))
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
