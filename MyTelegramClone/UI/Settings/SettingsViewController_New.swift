import UIKit

// MARK: - SettingsViewController v2.0 (из оригинала Telegram)
// Источник: mytelegram-iOS/submodules/SettingsUI/Sources/SettingsController.swift

class SettingsViewController_New: UIViewController {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Header с аватаром и именем
    private let headerView = SettingsHeaderView()
    
    // Секции настроек
    private let accountSection = SettingsSectionView()
    private let notificationsSection = SettingsSectionView()
    private let privacySection = SettingsSectionView()
    private let dataSection = SettingsSectionView()
    
    private var currentUser: User?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        setupUI()
        loadUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserProfile()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = TelegramTheme.Settings.blocksBackgroundColor
        
        // Scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Header (аватар + имя + username + bio)
        headerView.onEditProfile = { [weak self] in
            self?.editProfile()
        }
        contentView.addSubview(headerView)
        
        // Account section
        accountSection.title = "Account"
        accountSection.items = [
            SettingsItem(icon: "📱", title: "Phone Number", subtitle: "+7 999 123 4567", action: { [weak self] in
                self?.openPhoneNumber()
            }),
            SettingsItem(icon: "👤", title: "Username", subtitle: "@username", action: { [weak self] in
                self?.openUsername()
            }),
            SettingsItem(icon: "ℹ️", title: "Bio", subtitle: "Add a few words about yourself", action: { [weak self] in
                self?.openBio()
            })
        ]
        contentView.addSubview(accountSection)
        
        // Notifications section
        notificationsSection.title = "Settings"
        notificationsSection.items = [
            SettingsItem(icon: "🔔", title: "Notifications and Sounds", action: { [weak self] in
                self?.openNotifications()
            }),
            SettingsItem(icon: "🔒", title: "Privacy and Security", action: { [weak self] in
                self?.openPrivacy()
            }),
            SettingsItem(icon: "💾", title: "Data and Storage", action: { [weak self] in
                self?.openDataStorage()
            }),
            SettingsItem(icon: "🎨", title: "Appearance", action: { [weak self] in
                self?.openAppearance()
            })
        ]
        contentView.addSubview(notificationsSection)
        
        // Privacy section
        privacySection.title = "Support"
        privacySection.items = [
            SettingsItem(icon: "❓", title: "Ask a Question", action: { [weak self] in
                self?.openSupport()
            }),
            SettingsItem(icon: "💡", title: "Telegram FAQ", action: { [weak self] in
                self?.openFAQ()
            })
        ]
        contentView.addSubview(privacySection)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        accountSection.translatesAutoresizingMaskIntoConstraints = false
        notificationsSection.translatesAutoresizingMaskIntoConstraints = false
        privacySection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            accountSection.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            accountSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            accountSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            notificationsSection.topAnchor.constraint(equalTo: accountSection.bottomAnchor, constant: 32),
            notificationsSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            notificationsSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            privacySection.topAnchor.constraint(equalTo: notificationsSection.bottomAnchor, constant: 32),
            privacySection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            privacySection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            privacySection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - Data Loading
    
    private func loadUserProfile() {
        Task {
            do {
                let user = try await NetworkManager.shared.getCurrentUser()
                await MainActor.run {
                    self.currentUser = user
                    self.updateUI(with: user)
                }
            } catch {
                print("❌ Failed to load user profile: \(error)")
            }
        }
    }
    
    private func updateUI(with user: User) {
        headerView.configure(with: user)
        
        // Обновляем Account section
        accountSection.items = [
            SettingsItem(icon: "📱", title: "Phone Number", subtitle: user.phone ?? "Not set", action: { [weak self] in
                self?.openPhoneNumber()
            }),
            SettingsItem(icon: "👤", title: "Username", subtitle: user.username != nil ? "@\(user.username!)" : "Not set", action: { [weak self] in
                self?.openUsername()
            }),
            SettingsItem(icon: "ℹ️", title: "Bio", subtitle: user.bio ?? "Add a few words about yourself", action: { [weak self] in
                self?.openBio()
            })
        ]
    }
    
    // MARK: - Actions
    
    private func editProfile() {
        let alert = UIAlertController(title: "Edit Profile", message: "Choose what to edit", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Change Username", style: .default) { [weak self] _ in
            self?.openUsername()
        })
        
        alert.addAction(UIAlertAction(title: "Change Bio", style: .default) { [weak self] _ in
            self?.openBio()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func openPhoneNumber() {
        showAlert(title: "Phone Number", message: "Phone number cannot be changed in this demo")
    }
    
    private func openUsername() {
        let alert = UIAlertController(title: "Username", message: "Enter your username (without @)", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "username"
            textField.text = self.currentUser?.username
            textField.autocapitalizationType = .none
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let username = alert.textFields?.first?.text, !username.isEmpty else { return }
            self?.updateUsername(username)
        })
        
        present(alert, animated: true)
    }
    
    private func openBio() {
        let alert = UIAlertController(title: "Bio", message: "Add a few words about yourself", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Bio"
            textField.text = self.currentUser?.bio
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let bio = alert.textFields?.first?.text else { return }
            self?.updateBio(bio)
        })
        
        present(alert, animated: true)
    }
    
    private func updateUsername(_ username: String) {
        Task {
            do {
                let user = try await NetworkManager.shared.updateUsername(username)
                await MainActor.run {
                    self.currentUser = user
                    self.updateUI(with: user)
                    self.showAlert(title: "Success", message: "Username updated to @\(username)")
                }
            } catch {
                await MainActor.run {
                    self.showAlert(title: "Error", message: "Failed to update username. It may be already taken.")
                }
            }
        }
    }
    
    private func updateBio(_ bio: String) {
        Task {
            do {
                let user = try await NetworkManager.shared.updateBio(bio)
                await MainActor.run {
                    self.currentUser = user
                    self.updateUI(with: user)
                    self.showAlert(title: "Success", message: "Bio updated")
                }
            } catch {
                await MainActor.run {
                    self.showAlert(title: "Error", message: "Failed to update bio")
                }
            }
        }
    }
    
    private func openNotifications() {
        showAlert(title: "Notifications", message: "Coming soon")
    }
    
    private func openPrivacy() {
        showAlert(title: "Privacy", message: "Coming soon")
    }
    
    private func openDataStorage() {
        showAlert(title: "Data & Storage", message: "Coming soon")
    }
    
    private func openAppearance() {
        showAlert(title: "Appearance", message: "Coming soon - will add Dark Theme!")
    }
    
    private func openSupport() {
        showAlert(title: "Support", message: "Contact: @telegram")
    }
    
    private func openFAQ() {
        showAlert(title: "FAQ", message: "Visit telegram.org/faq")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Settings Header View (аватар + имя + username)

class SettingsHeaderView: UIView {
    
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let editButton = UIButton(type: .system)
    
    var onEditProfile: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Avatar (круг с первой буквой)
        avatarView.backgroundColor = TelegramTheme.accentColor
        avatarView.layer.cornerRadius = 40
        avatarView.clipsToBounds = true
        addSubview(avatarView)
        
        avatarLabel.font = .systemFont(ofSize: 32, weight: .medium)
        avatarLabel.textColor = .white
        avatarLabel.textAlignment = .center
        avatarView.addSubview(avatarLabel)
        
        // Name
        nameLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        nameLabel.textColor = TelegramTheme.Settings.itemPrimaryTextColor
        addSubview(nameLabel)
        
        // Username
        usernameLabel.font = .systemFont(ofSize: 16, weight: .regular)
        usernameLabel.textColor = TelegramTheme.Settings.itemSecondaryTextColor
        addSubview(usernameLabel)
        
        // Edit button
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        addSubview(editButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 80),
            avatarView.heightAnchor.constraint(equalToConstant: 80),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -8),
            
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            usernameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with user: User) {
        nameLabel.text = user.nameOrPhone
        usernameLabel.text = user.username != nil ? "@\(user.username!)" : "Set username"
        
        // Первая буква для аватара
        let firstLetter = String(user.shortName.prefix(1).uppercased())
        avatarLabel.text = firstLetter
    }
    
    @objc private func editTapped() {
        onEditProfile?()
    }
}

// MARK: - Settings Section View

class SettingsSectionView: UIView {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var items: [SettingsItem] = [] {
        didSet {
            updateItems()
        }
    }
    
    private let titleLabel = UILabel()
    private let containerView = UIView()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Title
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = TelegramTheme.Settings.sectionHeaderTextColor
        addSubview(titleLabel)
        
        // Container
        containerView.backgroundColor = TelegramTheme.Settings.itemBlocksBackgroundColor
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        // Stack view
        stackView.axis = .vertical
        containerView.addSubview(stackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func updateItems() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, item) in items.enumerated() {
            let itemView = SettingsItemView()
            itemView.configure(with: item)
            itemView.heightAnchor.constraint(equalToConstant: 44).isActive = true
            stackView.addArrangedSubview(itemView)
            
            // Separator
            if index < items.count - 1 {
                let separator = UIView()
                separator.backgroundColor = TelegramTheme.Settings.itemBlocksSeparatorColor
                separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                stackView.addArrangedSubview(separator)
            }
        }
    }
}

// MARK: - Settings Item View

class SettingsItemView: UIView {
    
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevronImageView = UIImageView()
    
    private var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Icon
        iconLabel.font = .systemFont(ofSize: 24)
        addSubview(iconLabel)
        
        // Title
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = TelegramTheme.Settings.itemPrimaryTextColor
        addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = TelegramTheme.Settings.itemSecondaryTextColor
        subtitleLabel.textAlignment = .right
        addSubview(subtitleLabel)
        
        // Chevron
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = TelegramTheme.Settings.disclosureArrowColor
        chevronImageView.contentMode = .scaleAspectFit
        addSubview(chevronImageView)
        
        // Tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            subtitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 8),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    func configure(with item: SettingsItem) {
        iconLabel.text = item.icon
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        subtitleLabel.isHidden = item.subtitle == nil
        self.action = item.action
    }
    
    @objc private func handleTap() {
        action?()
    }
}

// MARK: - Settings Item Model

struct SettingsItem {
    let icon: String
    let title: String
    var subtitle: String?
    let action: () -> Void
}
