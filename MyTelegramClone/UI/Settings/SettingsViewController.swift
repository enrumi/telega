import UIKit
class SettingsViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = TelegramTheme.Settings.blocksBackgroundColor
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private let settingsItems = [
        ("Profile", "person.circle"),
        ("Privacy", "lock.shield"),
        ("Notifications", "bell"),
        ("Data and Storage", "arrow.down.circle"),
        ("Appearance", "paintbrush"),
        ("Language", "globe"),
        ("Log Out", "arrow.right.square")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = TelegramTheme.Settings.blocksBackgroundColor
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = TelegramTheme.NavigationBar.opaqueBackgroundColor
        navigationController?.navigationBar.tintColor = TelegramTheme.NavigationBar.buttonColor
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SettingsCell")
        let item = settingsItems[indexPath.row]
        cell.textLabel?.text = item.0
        cell.textLabel?.font = TelegramFonts.settingsItemTitle
        cell.imageView?.image = UIImage(systemName: item.1)
        cell.imageView?.tintColor = TelegramTheme.accentColor
        if item.0 == "Log Out" {
            cell.textLabel?.textColor = TelegramTheme.Settings.itemDestructiveColor
            cell.imageView?.tintColor = TelegramTheme.Settings.itemDestructiveColor
        } else {
            cell.textLabel?.textColor = TelegramTheme.Settings.itemPrimaryTextColor
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = settingsItems[indexPath.row]
        if item.0 == "Log Out" {
            showLogoutConfirmation()
        } else {
            ")
            let alert = UIAlertController(
                title: item.0,
                message: "This screen is not implemented yet",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    private func showLogoutConfirmation() {
        let alert = UIAlertController(
            title: "Log Out",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { _ in
            NetworkManager.shared.clearAuth()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showAuthorizationInterface()
            } else if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.showAuthorizationInterface()
            }
        })
        present(alert, animated: true)
    }
}
