import UIKit
class GlobalSearchViewController: UIViewController {
    // MARK: - UI Components
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let emptyStateLabel = UILabel()
    private var searchResults: [SearchResult] = []
    private var isSearching = false
    var onChatSelected: ((Chat) -> Void)?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = TelegramTheme.SearchBar.backgroundColor
        // Search bar
        searchBar.placeholder = "Search by @username"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.backgroundColor = TelegramTheme.SearchBar.backgroundColor
        view.addSubview(searchBar)
        // Table view
        tableView.backgroundColor = TelegramTheme.ChatList.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 76, bottom: 0, right: 0)
        tableView.keyboardDismissMode = .onDrag
        view.addSubview(tableView)
        // Empty state
        emptyStateLabel.text = "Search for people by @username"
        emptyStateLabel.font = .systemFont(ofSize: 16)
        emptyStateLabel.textColor = TelegramTheme.ChatList.messageTextColor
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        view.addSubview(emptyStateLabel)
        setupConstraints()
    }
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    // MARK: - Search
    private func performSearch(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            tableView.reloadData()
            updateEmptyState()
            return
        }
        if query.hasPrefix("@") {
            searchByUsername(query)
        } else {
            searchByName(query)
        }
    }
    private func searchByUsername(_ username: String) {
        isSearching = true
        emptyStateLabel.text = "Searching..."
        Task {
            do {
                let user = try await NetworkManager.shared.searchUserByUsername(username)
                let chat = try await NetworkManager.shared.searchChatByUsername(username)
                await MainActor.run {
                    self.searchResults = [
                        SearchResult(
                            id: Int(user.id),
                            title: user.nameOrPhone,
                            subtitle: user.username != nil ? "@\(user.username!)" : nil,
                            avatarUrl: user.avatarUrl,
                            chat: chat
                        )
                    ]
                    self.tableView.reloadData()
                    self.updateEmptyState()
                    self.isSearching = false
                }
            } catch {
                await MainActor.run {
                    ")
                    self.searchResults = []
                    self.emptyStateLabel.text = "User not found"
                    self.tableView.reloadData()
                    self.isSearching = false
                }
            }
        }
    }
    private func searchByName(_ query: String) {
        // TODO: implement name search when backend supports it
        emptyStateLabel.text = "Try searching by @username"
        searchResults = []
        tableView.reloadData()
    }
    private func updateEmptyState() {
        if searchResults.isEmpty && !isSearching {
            emptyStateLabel.isHidden = false
            if searchBar.text?.isEmpty ?? true {
                emptyStateLabel.text = "Search for people by @username"
            }
        } else {
            emptyStateLabel.isHidden = true
        }
    }
}
// MARK: - UISearchBarDelegate
extension GlobalSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            performSearch(text)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchResults = []
        tableView.reloadData()
        updateEmptyState()
    }
}
// MARK: - UITableViewDataSource
extension GlobalSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as! SearchResultCell
        let result = searchResults[indexPath.row]
        cell.configure(with: result)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension GlobalSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = searchResults[indexPath.row]
        if let chat = result.chat {
            onChatSelected?(chat)
            navigationController?.popViewController(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
// MARK: - SearchResult Model
struct SearchResult {
    let id: Int
    let title: String
    let subtitle: String?
    let avatarUrl: String?
    let chat: Chat?
}
// MARK: - SearchResultCell
class SearchResultCell: UITableViewCell {
    static let reuseIdentifier = "SearchResultCell"
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        backgroundColor = TelegramTheme.ChatList.itemBackgroundColor
        // Avatar
        avatarView.layer.cornerRadius = 30
        avatarView.clipsToBounds = true
        contentView.addSubview(avatarView)
        avatarLabel.font = .systemFont(ofSize: 20, weight: .medium)
        avatarLabel.textColor = .white
        avatarLabel.textAlignment = .center
        avatarView.addSubview(avatarLabel)
        // Title
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = TelegramTheme.ChatList.titleColor
        contentView.addSubview(titleLabel)
        // Subtitle
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = TelegramTheme.ChatList.messageTextColor
        contentView.addSubview(subtitleLabel)
        setupConstraints()
    }
    private func setupConstraints() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    func configure(with result: SearchResult) {
        titleLabel.text = result.title
        subtitleLabel.text = result.subtitle
        // Avatar
        let firstLetter = String(result.title.prefix(1).uppercased())
        avatarLabel.text = firstLetter
        let colors: [UIColor] = [
            UIColor(rgb: 0xfc5c51),
            UIColor(rgb: 0xfa790f),
            UIColor(rgb: 0x895dd5),
            UIColor(rgb: 0x0fb297),
            UIColor(rgb: 0x00c0c5),
            UIColor(rgb: 0x3ca5ec),
            UIColor(rgb: 0x3d72ed)
        ]
        let colorIndex = abs(result.id % colors.count)
        avatarView.backgroundColor = colors[colorIndex]
    }
}
