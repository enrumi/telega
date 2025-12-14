import UIKit

// MARK: - AuthorizationCodeViewController (с AuthorizationCodeNode из оригинала)

class AuthorizationCodeViewController_New: UIViewController {
    
    private var codeNode: AuthorizationCodeNode!
    private let phoneNumber: String
    
    // MARK: - Init
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        // Используем AuthorizationCodeNode как корневой view (как в оригинале)
        codeNode = AuthorizationCodeNode(theme: TelegramTheme.self)
        codeNode.phoneNumber = phoneNumber
        
        codeNode.loginWithCode = { [weak self] code in
            self?.verifyCode(code)
        }
        
        codeNode.requestNextOption = { [weak self] in
            self?.requestNextOption()
        }
        
        codeNode.reset = { [weak self] in
            self?.resendCode()
        }
        
        self.view = codeNode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = phoneNumber
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeNode.activateInput()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = TelegramTheme.NavigationBar.buttonColor
        navigationController?.navigationBar.backgroundColor = TelegramTheme.NavigationBar.opaqueBackgroundColor
    }
    
    // MARK: - Actions
    
    private func verifyCode(_ code: String) {
        print("🔐 Проверка кода: \(code)")
        
        codeNode.inProgress = true
        
        Task {
            do {
                let response = try await NetworkManager.shared.login(phone: phoneNumber, code: code)
                print("✅ Авторизация успешна: \(response)")
                
                await MainActor.run {
                    self.codeNode.inProgress = false
                    self.navigateToMainApp()
                }
            } catch {
                print("❌ Ошибка: \(error.localizedDescription)")
                await MainActor.run {
                    self.codeNode.inProgress = false
                    self.codeNode.showError("Invalid code. Please try again.")
                }
            }
        }
    }
    
    private func requestNextOption() {
        let alert = UIAlertController(
            title: "Didn't receive the code?",
            message: "Choose another option to receive your code",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Call me", style: .default) { [weak self] _ in
            print("📞 Запрос звонка")
            self?.showAlert(title: "Call Requested", message: "You will receive a call with your code shortly.")
        })
        
        alert.addAction(UIAlertAction(title: "Send via SMS", style: .default) { [weak self] _ in
            print("📱 Запрос SMS")
            self?.resendCode()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func resendCode() {
        print("🔄 Повторная отправка кода")
        
        codeNode.inProgress = true
        
        Task {
            do {
                // В реальном приложении здесь был бы метод resendCode()
                // Для демо просто показываем уведомление
                print("🔄 Повторная отправка кода")
                
                await MainActor.run {
                    self.codeNode.inProgress = false
                    self.showAlert(title: "Code Sent", message: "A new code has been sent to \(self.phoneNumber)")
                }
            }
        }
    }
    
    private func navigateToMainApp() {
        // Переход на MainTabBarController
        let mainVC = MainTabBarController()
        
        if let window = view.window {
            window.rootViewController = mainVC
            
            // Анимация перехода (как в оригинале Telegram)
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
