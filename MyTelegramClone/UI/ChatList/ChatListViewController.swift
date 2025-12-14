import UIKit

// MARK: - Список чатов (1:1 с Telegram)
class ChatListViewController: UIViewController {
    
    private var chats: [Chat] = []
    private var isLoading = false
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = TelegramTheme.ChatList.backgroundColor
        table.separatorColor = TelegramTheme.ChatList.itemSeparatorColor
        table.separatorInset = UIEdgeInsets(top: 0, left: 76, bottom: 0, right: 0)
        table.rowHeight = 76
        table.delegate = self
        table.dataSource = self
        table.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No chats yet"
        label.font = TelegramFonts.chatListMessage
        label.textColor = TelegramTheme.ChatList.messageColor
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        loadChats()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = TelegramTheme.ChatList.backgroundColor
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Chats"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = TelegramTheme.NavigationBar.backgroundColor
        navigationController?.navigationBar.tintColor = TelegramTheme.NavigationBar.buttonColor
        
        // Кнопка "Compose"
        let composeButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(composeButtonTapped)
        )
        navigationItem.rightBarButtonItem = composeButton
        
        // Кнопка "Edit"
        let editButton = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
        navigationItem.leftBarButtonItem = editButton
    }
    
    // MARK: - Data Loading
    
    private func loadChats() {
        guard !isLoading else { return }
        
        isLoading = true
        activityIndicator.startAnimating()
        emptyStateLabel.isHidden = true
        
        Task {
            do {
                let fetchedChats = try await NetworkManager.shared.fetchChats()
                
                await MainActor.run {
                    self.chats = fetchedChats
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.isLoading = false
                    
                    self.emptyStateLabel.isHidden = !fetchedChats.isEmpty
                    
                    print("✅ Загружено чатов: \(fetchedChats.count)")
                }
            } catch {
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.isLoading = false
                    
                    print("❌ Ошибка загрузки чатов: \(error)")
                    
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Failed to load chats. Please try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                        self.loadChats()
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func composeButtonTapped() {
        print("📝 Compose button tapped")
        
        let alert = UIAlertController(
            title: "New Chat",
            message: "Creating new chats requires backend implementation",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func editButtonTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    @objc private func refreshChats() {
        loadChats()
    }
}

// MARK: - UITableViewDataSource
extension ChatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.reuseIdentifier, for: indexPath) as! ChatListCell
        let chat = chats[indexPath.row]
        cell.configure(with: chat)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chat = chats[indexPath.row]
        print("💬 Открываем чат: \(chat.title)")
        
        let chatViewController = ChatViewController(chat: chat)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.chats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        let archiveAction = UIContextualAction(style: .normal, title: "Archive") { _, _, completion in
            completion(true)
        }
        archiveAction.backgroundColor = .systemGray
        
        return UISwipeActionsConfiguration(actions: [deleteAction, archiveAction])
    }
}
