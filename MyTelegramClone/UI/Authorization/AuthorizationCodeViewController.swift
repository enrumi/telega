import UIKit

// MARK: - Экран ввода кода подтверждения (1:1 с Telegram)
class AuthorizationCodeViewController: UIViewController {
    
    private let phoneNumber: String
    var onAuthSuccess: (() -> Void)?
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = TelegramFonts.authTitle
        label.textColor = TelegramTheme.Authorization.primaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "We have sent you a code.\nPlease enter it below."
        label.font = TelegramFonts.authDescription
        label.textColor = TelegramTheme.ChatList.messageTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Code"
        textField.font = TelegramFonts.authInput
        textField.textColor = TelegramTheme.Authorization.inputFieldPrimaryColor
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.backgroundColor = TelegramTheme.Authorization.inputFieldBackgroundColor
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Init
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        setupKeyboardObservers()
        
        titleLabel.text = phoneNumber
        
        codeTextField.delegate = self
        codeTextField.addTarget(self, action: #selector(codeTextFieldChanged), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeTextField.becomeFirstResponder()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = TelegramTheme.Authorization.backgroundColor
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(codeTextField)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Code TextField
            codeTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            codeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            codeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            codeTextField.heightAnchor.constraint(equalToConstant: 56),
            codeTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        title = ""
        
        navigationController?.navigationBar.tintColor = TelegramTheme.NavigationBar.buttonColor
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Actions
    
    @objc private func codeTextFieldChanged() {
        guard let code = codeTextField.text, code.count == 5 else { return }
        
        // Автоматически отправляем код когда введено 5 цифр
        performLogin(code: code)
    }
    
    private func performLogin(code: String) {
        print("🔐 Отправляем код: \(code)")
        
        codeTextField.resignFirstResponder()
        activityIndicator.startAnimating()
        codeTextField.isEnabled = false
        
        Task {
            do {
                let response = try await NetworkManager.shared.login(phone: phoneNumber, code: code)
                
                await MainActor.run {
                    activityIndicator.stopAnimating()
                    codeTextField.isEnabled = true
                    
                    print("✅ Авторизация успешна! userId=\(response.userId)")
                    
                    // Показываем главный экран
                    onAuthSuccess?()
                }
            } catch {
                await MainActor.run {
                    activityIndicator.stopAnimating()
                    codeTextField.isEnabled = true
                    
                    print("❌ Ошибка авторизации: \(error)")
                    
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Invalid code. Please try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.codeTextField.text = ""
                        self.codeTextField.becomeFirstResponder()
                    })
                    present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate
extension AuthorizationCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Только цифры
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }
        
        // Максимум 5 цифр
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        return newLength <= 5
    }
}
