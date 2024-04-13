import UIKit

final class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel: BigViewModel
    private var user = User() {
        didSet {
            nameLabel.text = user.name
        }
    }
    
    private var cards:[BankCard] = [
        BankCard(id: 12, bank: Bank(id: 12, name: "Jusan", image: nil), name: "Jusan", image: nil, comment: nil),
        BankCard(id: 12, bank: Bank(id: 12, name: "Jusan", image: nil), name: "Jusan", image: nil, comment: nil),
        BankCard(id: 12, bank: Bank(id: 12, name: "Jusan", image: nil), name: "Jusan", image: nil, comment: nil),
        BankCard(id: 12, bank: Bank(id: 12, name: "Jusan", image: nil), name: "Jusan", image: nil, comment: nil),
        BankCard(id: 12, bank: Bank(id: 12, name: "Jusan", image: nil), name: "Jusan", image: nil, comment: nil),
    ] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(viewModel: BigViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Name label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ilyas"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // Table view
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BankCardTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Logout button
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выйти", for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view
        view.backgroundColor = .black
        navigationController?.isNavigationBarHidden = false
        // Add subviews
        view.addSubview(nameLabel)
        view.addSubview(tableView)
        view.addSubview(logoutButton)
        
        // Set up constraints
        setupConstraints()
        
        // Set the table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        // Name label constraints
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // Table view constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -20)
        ])
        
        // Logout button constraints
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? BankCardTableViewCell else {
            return UITableViewCell()
        }
        cell.card = cards[indexPath.row]
        cell.configureForprofile()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Check if the editing style is delete
        if editingStyle == .delete {
            // Perform the deletion of the data item associated with the cell
            // Assuming you have an array of data source (e.g., dataArray) to remove the item from
            cards.remove(at: indexPath.row)
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // UITableViewDelegate methods (optional)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle table view cell selection
        print("Selected item at index \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    // Logout button action
    @objc private func logoutButtonTapped() {
        print("Logout button tapped")
    }
}

extension ProfileViewController {
    func loadCards() {
        Task {
            let result = await NetworkManager.shared.getBanks()
            switch result {
            case .success(let _):
                DispatchQueue.main.async {
                    self.cards = []
                }
            case .failure(let error):
                print("Failed to fetch banks: \(error)")
            }
        }
    }
}
