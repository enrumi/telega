import UIKit

// MARK: - AuthorizationPhoneViewController (с AuthorizationPhoneNode из оригинала)

class AuthorizationPhoneViewController_New: UIViewController {
    
    private var phoneNode: AuthorizationPhoneNode!
    private var selectedCountry: Country?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        // Используем AuthorizationPhoneNode как корневой view (как в оригинале)
        phoneNode = AuthorizationPhoneNode(theme: TelegramTheme.self, hasOtherAccounts: false)
        
        phoneNode.selectCountryCode = { [weak self] in
            self?.selectCountry()
        }
        
        phoneNode.checkPhone = { [weak self] in
            self?.sendCode()
        }
        
        phoneNode.debugAction = {
            print("🔧 Debug action triggered")
        }
        
        self.view = phoneNode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Phone Number"
        setupNavigationBar()
        loadDefaultCountry()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneNode.activateInput()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = TelegramTheme.NavigationBar.buttonColor
        navigationController?.navigationBar.backgroundColor = TelegramTheme.NavigationBar.opaqueBackgroundColor
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func loadDefaultCountry() {
        // По умолчанию Россия
        // Используем существующую модель Country
        phoneNode.updateCountry(name: "Russia", code: "+7", flag: "🇷🇺")
    }
    
    // MARK: - Actions
    
    private func selectCountry() {
        let countryVC = CountrySelectionViewController()
        countryVC.onCountrySelected = { [weak self] country in
            self?.selectedCountry = country
            self?.phoneNode.updateCountry(
                name: country.name,
                code: country.code,
                flag: "🌍" // TODO: добавить флаги в Country модель
            )
        }
        navigationController?.pushViewController(countryVC, animated: true)
    }
    
    private func sendCode() {
        let (code, codeStr, number) = phoneNode.codeAndNumber
        let fullPhoneNumber = (codeStr ?? "") + number
        
        guard !fullPhoneNumber.isEmpty else {
            showAlert(title: "Error", message: "Please enter your phone number")
            return
        }
        
        print("📱 Отправка кода на: \(fullPhoneNumber)")
        
        phoneNode.inProgress = true
        
        Task {
            do {
                // В реальном приложении здесь был бы запрос только на отправку кода
                // Но у нас упрощённый API, так что просто переходим на следующий экран
                print("📱 Отправка кода на: \(fullPhoneNumber)")
                
                await MainActor.run {
                    self.phoneNode.inProgress = false
                    
                    // Переходим на экран ввода кода
                    let codeVC = AuthorizationCodeViewController_New(phoneNumber: fullPhoneNumber)
                    self.navigationController?.pushViewController(codeVC, animated: true)
                }
            } catch {
                await MainActor.run {
                    self.phoneNode.inProgress = false
                    self.showAlert(
                        title: "Error",
                        message: "Failed to send code. Please try again."
                    )
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
