import UIKit

// MARK: - AuthorizationPhoneNode
// Портировано из mytelegram-iOS/submodules/AuthorizationUI/Sources/AuthorizationSequencePhoneEntryControllerNode.swift
// Оригинал: 1246 строк, AsyncDisplayKit → UIKit

// MARK: - Phone Input Field (из оригинала, строки 18-263)

final class PhoneInputNode: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private let theme: TelegramTheme.Type
    private let strings: [String: String] = [
        "phoneNumber": "Phone Number",
        "countryCode": "Country Code"
    ]
    
    var countryCodeField: UITextField!
    var numberField: UITextField!
    private let separatorView = UIView()
    
    var enableEditing: Bool = true {
        didSet {
            countryCodeField.isEnabled = enableEditing
            numberField.isEnabled = enableEditing
        }
    }
    
    var number: String {
        return (countryCodeField.text ?? "") + (numberField.text ?? "")
    }
    
    var codeAndNumber: (Int32?, String?, String) {
        get {
            let code = countryCodeField.text ?? ""
            let number = numberField.text ?? ""
            return (Int32(code), code, number)
        }
        set {
            if let codeValue = newValue.1 {
                countryCodeField.text = codeValue
            }
            numberField.text = newValue.2
        }
    }
    
    var formattedCodeAndNumber: (String, String) {
        return (countryCodeField.text ?? "", numberField.text ?? "")
    }
    
    var numberChanged: (() -> Void)?
    
    // MARK: - Init
    
    init(theme: TelegramTheme.Type) {
        self.theme = theme
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup (из оригинала)
    
    private func setupViews() {
        backgroundColor = theme.Authorization.inputFieldBackgroundColor
        layer.cornerRadius = 12
        
        // Country code field (+7, +1, etc)
        countryCodeField = UITextField()
        countryCodeField.textAlignment = .center
        countryCodeField.font = .systemFont(ofSize: 20, weight: .regular)
        countryCodeField.textColor = theme.Authorization.inputFieldPrimaryColor
        countryCodeField.keyboardType = .numberPad
        countryCodeField.delegate = self
        countryCodeField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addSubview(countryCodeField)
        
        // Separator
        separatorView.backgroundColor = theme.Authorization.inputFieldStrokeColor
        addSubview(separatorView)
        
        // Phone number field
        numberField = UITextField()
        numberField.font = .systemFont(ofSize: 20, weight: .regular)
        numberField.textColor = theme.Authorization.inputFieldPrimaryColor
        numberField.keyboardType = .phonePad
        numberField.delegate = self
        numberField.placeholder = strings["phoneNumber"]
        numberField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addSubview(numberField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let codeWidth: CGFloat = 80
        let separatorWidth: CGFloat = 1
        
        countryCodeField.frame = CGRect(
            x: 0,
            y: 0,
            width: codeWidth,
            height: bounds.height
        )
        
        separatorView.frame = CGRect(
            x: codeWidth,
            y: 12,
            width: separatorWidth,
            height: bounds.height - 24
        )
        
        numberField.frame = CGRect(
            x: codeWidth + separatorWidth + 16,
            y: 0,
            width: bounds.width - codeWidth - separatorWidth - 32,
            height: bounds.height
        )
    }
    
    @objc private func textFieldDidChange() {
        numberChanged?()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ограничение на цифры
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

// MARK: - Phone and Country Node (из оригинала, строки 18-263)

final class PhoneAndCountryNode: UIView {
    
    let phoneInputNode: PhoneInputNode
    let countryButton: UIButton
    private let countryLabel: UILabel
    private let flagLabel: UILabel
    
    var selectCountryCode: (() -> Void)?
    
    init(theme: TelegramTheme.Type) {
        phoneInputNode = PhoneInputNode(theme: theme)
        countryButton = UIButton(type: .system)
        countryLabel = UILabel()
        flagLabel = UILabel()
        
        super.init(frame: .zero)
        
        // Country button
        countryButton.backgroundColor = theme.Authorization.inputFieldBackgroundColor
        countryButton.layer.cornerRadius = 12
        countryButton.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
        addSubview(countryButton)
        
        // Flag
        flagLabel.font = .systemFont(ofSize: 32)
        flagLabel.text = "🇷🇺"
        countryButton.addSubview(flagLabel)
        
        // Country name
        countryLabel.font = .systemFont(ofSize: 17, weight: .regular)
        countryLabel.textColor = theme.Authorization.inputFieldPrimaryColor
        countryLabel.text = "Russia"
        countryButton.addSubview(countryLabel)
        
        // Phone input
        addSubview(phoneInputNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let countryHeight: CGFloat = 56
        let spacing: CGFloat = 12
        let phoneHeight: CGFloat = 56
        
        countryButton.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: countryHeight
        )
        
        flagLabel.frame = CGRect(
            x: 16,
            y: (countryHeight - 32) / 2,
            width: 40,
            height: 32
        )
        
        countryLabel.frame = CGRect(
            x: 64,
            y: 0,
            width: bounds.width - 80,
            height: countryHeight
        )
        
        phoneInputNode.frame = CGRect(
            x: 0,
            y: countryHeight + spacing,
            width: bounds.width,
            height: phoneHeight
        )
    }
    
    @objc private func countryButtonTapped() {
        selectCountryCode?()
    }
    
    func updateCountry(name: String, code: String, flag: String) {
        countryLabel.text = name
        flagLabel.text = flag
        phoneInputNode.countryCodeField.text = code
    }
}

// MARK: - AuthorizationPhoneNode (главный контейнер, из оригинала строки 296-730)

final class AuthorizationPhoneNode: UIView {
    
    private let theme: TelegramTheme.Type
    
    // UI Components (из оригинала)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let animationImageView = UIImageView()
    private let titleLabel = UILabel()
    private let noticeLabel = UILabel()
    private let phoneAndCountryNode: PhoneAndCountryNode
    private let proceedButton = UIButton(type: .system)
    
    private let qrButton = UIButton(type: .system)
    
    // Callbacks
    var selectCountryCode: (() -> Void)?
    var checkPhone: (() -> Void)?
    var debugAction: (() -> Void)?
    
    var inProgress: Bool = false {
        didSet {
            phoneAndCountryNode.phoneInputNode.enableEditing = !inProgress
            phoneAndCountryNode.phoneInputNode.alpha = inProgress ? 0.6 : 1.0
            phoneAndCountryNode.countryButton.isEnabled = !inProgress
            
            if inProgress {
                proceedButton.isEnabled = false
                proceedButton.setTitle("Loading...", for: .disabled)
            } else {
                proceedButton.isEnabled = true
            }
        }
    }
    
    var currentNumber: String {
        return phoneAndCountryNode.phoneInputNode.number
    }
    
    var codeAndNumber: (Int32?, String?, String) {
        get { phoneAndCountryNode.phoneInputNode.codeAndNumber }
        set { phoneAndCountryNode.phoneInputNode.codeAndNumber = newValue }
    }
    
    var formattedCodeAndNumber: (String, String) {
        return phoneAndCountryNode.phoneInputNode.formattedCodeAndNumber
    }
    
    // MARK: - Init
    
    init(theme: TelegramTheme.Type, hasOtherAccounts: Bool) {
        self.theme = theme
        self.phoneAndCountryNode = PhoneAndCountryNode(theme: theme)
        
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup (из оригинала, строки 377-500)
    
    private func setupViews() {
        backgroundColor = theme.Authorization.backgroundColor
        
        // Scroll view
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Animation (заменили AnimatedStickerNode на простую картинку)
        animationImageView.image = UIImage(systemName: "phone.circle.fill")
        animationImageView.tintColor = theme.Authorization.accentTextColor
        animationImageView.contentMode = .scaleAspectFit
        contentView.addSubview(animationImageView)
        
        // Title (из оригинала, строка 395)
        titleLabel.text = "Your Phone Number"
        titleLabel.font = .systemFont(ofSize: 30, weight: .light)
        titleLabel.textColor = theme.Authorization.primaryTextColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        // Notice (из оригинала, строка 402)
        noticeLabel.text = "Please confirm your country code\nand enter your phone number."
        noticeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        noticeLabel.textColor = theme.Authorization.primaryTextColor
        noticeLabel.textAlignment = .center
        noticeLabel.numberOfLines = 0
        contentView.addSubview(noticeLabel)
        
        // Phone and country
        phoneAndCountryNode.selectCountryCode = { [weak self] in
            self?.selectCountryCode?()
        }
        phoneAndCountryNode.phoneInputNode.numberChanged = { [weak self] in
            self?.updateProceedButton()
        }
        contentView.addSubview(phoneAndCountryNode)
        
        // Proceed button (из оригинала, SolidRoundedButtonNode)
        proceedButton.setTitle("Next", for: .normal)
        proceedButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        proceedButton.setTitleColor(.white, for: .normal)
        proceedButton.backgroundColor = theme.Authorization.accentTextColor
        proceedButton.layer.cornerRadius = 12
        proceedButton.addTarget(self, action: #selector(proceedButtonTapped), for: .touchUpInside)
        proceedButton.isEnabled = false
        proceedButton.alpha = 0.5
        contentView.addSubview(proceedButton)
        
        // QR code button (из оригинала)
        qrButton.setTitle("Log in by QR Code", for: .normal)
        qrButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        qrButton.setTitleColor(theme.Authorization.accentTextColor, for: .normal)
        qrButton.addTarget(self, action: #selector(qrButtonTapped), for: .touchUpInside)
        contentView.addSubview(qrButton)
        
        // Debug action (long press на title)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 3.0
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(longPress)
        
        // Keyboard notifications
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
    
    // MARK: - Layout (из оригинала, строки 500-650)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        
        let width = bounds.width
        let padding: CGFloat = 32
        let contentWidth = width - padding * 2
        
        var offsetY: CGFloat = 60
        
        // Animation
        let animationSize: CGFloat = 120
        animationImageView.frame = CGRect(
            x: (width - animationSize) / 2,
            y: offsetY,
            width: animationSize,
            height: animationSize
        )
        offsetY += animationSize + 24
        
        // Title
        titleLabel.frame = CGRect(
            x: padding,
            y: offsetY,
            width: contentWidth,
            height: 80
        )
        titleLabel.sizeToFit()
        titleLabel.frame.size.width = contentWidth
        offsetY += titleLabel.frame.height + 16
        
        // Notice
        noticeLabel.frame = CGRect(
            x: padding,
            y: offsetY,
            width: contentWidth,
            height: 60
        )
        noticeLabel.sizeToFit()
        noticeLabel.frame.size.width = contentWidth
        offsetY += noticeLabel.frame.height + 32
        
        // Phone and country (country button + phone input = 124pt высота)
        phoneAndCountryNode.frame = CGRect(
            x: padding,
            y: offsetY,
            width: contentWidth,
            height: 124
        )
        offsetY += 124 + 24
        
        // Proceed button
        proceedButton.frame = CGRect(
            x: padding,
            y: offsetY,
            width: contentWidth,
            height: 50
        )
        offsetY += 50 + 24
        
        // QR button
        qrButton.frame = CGRect(
            x: padding,
            y: offsetY,
            width: contentWidth,
            height: 44
        )
        offsetY += 44 + 40
        
        contentView.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: offsetY
        )
        scrollView.contentSize = contentView.bounds.size
    }
    
    // MARK: - Actions
    
    @objc private func proceedButtonTapped() {
        checkPhone?()
    }
    
    @objc private func qrButtonTapped() {
        // TODO: QR code login
        print("📱 QR Code login")
    }
    
    @objc private func handleLongPress() {
        debugAction?()
    }
    
    private func updateProceedButton() {
        let hasNumber = !phoneAndCountryNode.phoneInputNode.number.isEmpty
        proceedButton.isEnabled = hasNumber && !inProgress
        proceedButton.alpha = hasNumber ? 1.0 : 0.5
    }
    
    // MARK: - Keyboard handling (из оригинала)
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        
        // Scroll to phone input
        let phoneFrame = phoneAndCountryNode.frame
        scrollView.scrollRectToVisible(phoneFrame, animated: true)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    // MARK: - Public API
    
    func updateCountry(name: String, code: String, flag: String) {
        phoneAndCountryNode.updateCountry(name: name, code: code, flag: flag)
        updateProceedButton()
    }
    
    func activateInput() {
        phoneAndCountryNode.phoneInputNode.numberField.becomeFirstResponder()
    }
}
