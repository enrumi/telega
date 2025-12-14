import UIKit
class CountrySelectionViewController: UIViewController {
    var onCountrySelected: ((Country) -> Void)?
    private var countries: [Country] = []
    private var filteredCountries: [Country] = []
    // MARK: - UI Elements
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search"
        controller.searchBar.tintColor = TelegramTheme.accentColor
        return controller
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = TelegramTheme.Settings.plainBackgroundColor
        table.separatorColor = TelegramTheme.Common.separatorColor
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCountries()
    }
    // MARK: - Setup
    private func setupUI() {
        title = "Country"
        view.backgroundColor = TelegramTheme.Settings.plainBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = TelegramTheme.NavigationBar.buttonColor
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    private func loadCountries() {
        countries = CountryManager.shared.countries
        filteredCountries = countries
        tableView.reloadData()
    }
}
// MARK: - UITableViewDataSource
extension CountrySelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let country = filteredCountries[indexPath.row]
        cell.textLabel?.text = country.displayName
        cell.textLabel?.font = TelegramFonts.settingsItemTitle
        cell.textLabel?.textColor = TelegramTheme.Settings.itemPrimaryTextColor
        cell.backgroundColor = TelegramTheme.Settings.itemBlocksBackgroundColor
        return cell
    }
}
// MARK: - UITableViewDelegate
extension CountrySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = filteredCountries[indexPath.row]
        onCountrySelected?(country)
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - UISearchResultsUpdating
extension CountrySelectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        if query.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = CountryManager.shared.searchCountries(query: query)
        }
        tableView.reloadData()
    }
}
