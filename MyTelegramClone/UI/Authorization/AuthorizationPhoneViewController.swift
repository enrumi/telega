import UIKit

// MARK: - Экран ввода номера телефона (1:1 с Telegram)
class AuthorizationPhoneViewController: UIViewController {
    
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
        label.text = "Your Phone Number"
        label.font = TelegramFonts.authTitle
        label.textColor = TelegramTheme.Authorization.primaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please confirm your country code\nand enter your phone number."
        label.font = TelegramFonts.authDescription
        label.textColor = TelegramTheme.ChatList.messageTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Russia", for: .normal)
        button.setTitleColor(TelegramTheme.Authorization.primaryTextColor, for: .normal)
        button.titleLabel?.font = TelegramFonts.authInput
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Стрелка справа
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = TelegramTheme.ChatList.messageTextColor
        chevron.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            chevron.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: button.trailingAnchor),
        ])
        
        return button
    }()
    
    private var selectedCountry: Country = {
        // По умолчанию Russia (+7)
        return CountryManager.shared.findCountry(byCode: "7") ?? 
               Country(code: "7", countryCode: "RU", mask: "XXX XXX XXXX", name: "Russia")
    }()
    
    private let phoneContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = TelegramTheme.Authorization.inputFieldBackgroundColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countryCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "+7"
        label.font = TelegramFonts.authInput
        label.textColor = TelegramTheme.Authorization.inputFieldPrimaryColor
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "000 000 00 00"
        textField.font = TelegramFonts.authInput
        textField.textColor = TelegramTheme.Authorization.inputFieldPrimaryColor
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = TelegramTheme.Common.separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        setupKeyboardObservers()
        
        phoneTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(phoneTextFieldChanged), for: .editingChanged)
        
        countryButton.addTarget(self, action: #selector(selectCountryTapped), for: .touchUpInside)
        
        updateCountryDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = TelegramTheme.Authorization.backgroundColor
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(countryButton)
        contentView.addSubview(separatorView)
        contentView.addSubview(phoneContainerView)
        
        phoneContainerView.addSubview(countryCodeLabel)
        phoneContainerView.addSubview(phoneTextField)
        
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
            
            // Country Button
            countryButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            countryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            countryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            countryButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Separator
            separatorView.topAnchor.constraint(equalTo: countryButton.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            // Phone Container
            phoneContainerView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            phoneContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            phoneContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            phoneContainerView.heightAnchor.constraint(equalToConstant: 56),
            phoneContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Country Code
            countryCodeLabel.leadingAnchor.constraint(equalTo: phoneContainerView.leadingAnchor, constant: 16),
            countryCodeLabel.centerYAnchor.constraint(equalTo: phoneContainerView.centerYAnchor),
            
            // Phone TextField
            phoneTextField.leadingAnchor.constraint(equalTo: countryCodeLabel.trailingAnchor, constant: 12),
            phoneTextField.trailingAnchor.constraint(equalTo: phoneContainerView.trailingAnchor, constant: -16),
            phoneTextField.centerYAnchor.constraint(equalTo: phoneContainerView.centerYAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        title = ""
        
        // Кнопка Next
        let nextButton = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(nextButtonTapped)
        )
        nextButton.isEnabled = false
        navigationItem.rightBarButtonItem = nextButton
        
        // Применяем тему
        navigationController?.navigationBar.tintColor = TelegramTheme.NavigationBar.buttonColor
        navigationController?.navigationBar.backgroundColor = TelegramTheme.NavigationBar.backgroundColor
        navigationController?.navigationBar.isTranslucent = true
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
    
    @objc private func nextButtonTapped() {
        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else { return }
        
        let fullPhone = "+\(selectedCountry.code)" + phoneNumber.replacingOccurrences(of: " ", with: "")
        
        print("📞 Переходим к вводу кода для номера: \(fullPhone)")
        
        let codeViewController = AuthorizationCodeViewController(phoneNumber: fullPhone)
        codeViewController.onAuthSuccess = { [weak self] in
            self?.onAuthSuccess?()
        }
        navigationController?.pushViewController(codeViewController, animated: true)
    }
    
    @objc private func selectCountryTapped() {
        let countrySelectionVC = CountrySelectionViewController()
        countrySelectionVC.onCountrySelected = { [weak self] country in
            self?.selectedCountry = country
            self?.updateCountryDisplay()
        }
        navigationController?.pushViewController(countrySelectionVC, animated: true)
    }
    
    private func updateCountryDisplay() {
        countryButton.setTitle(selectedCountry.name, for: .normal)
        countryCodeLabel.text = "+\(selectedCountry.code)"
    }
    
    @objc private func phoneTextFieldChanged() {
        let isValid = (phoneTextField.text?.count ?? 0) >= 10
        navigationItem.rightBarButtonItem?.isEnabled = isValid
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
extension AuthorizationPhoneViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Только цифры
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
