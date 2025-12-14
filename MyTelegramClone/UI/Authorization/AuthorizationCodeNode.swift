import UIKit

// MARK: - Code Input View (из оригинала, поле для ввода кода)
// Портировано из AuthorizationSequenceCodeEntryControllerNode.swift, строки 46-84

final class CodeInputView: UIView, UITextFieldDelegate {
    
    private let codeLength = 5
    private var codeDigitViews: [UIView] = []
    private var codeLabels: [UILabel] = []
    private let textField = UITextField()
    
    var text: String {
        return textField.text ?? ""
    }
    
    var textChanged: ((String) -> Void)?
    
    private let theme: TelegramTheme.Type
    
    init(theme: TelegramTheme.Type) {
        self.theme = theme
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Скрытое текстовое поле для ввода
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.delegate = self
        textField.alpha = 0
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addSubview(textField)
        
        // Создаём 5 квадратиков для цифр (как в оригинале)
        for i in 0..<codeLength {
            let digitView = UIView()
            digitView.backgroundColor = theme.Authorization.inputFieldBackgroundColor
            digitView.layer.cornerRadius = 12
            digitView.layer.borderWidth = 2
            digitView.layer.borderColor = theme.Authorization.inputFieldStrokeColor.cgColor
            addSubview(digitView)
            codeDigitViews.append(digitView)
            
            let label = UILabel()
            label.font = .systemFont(ofSize: 32, weight: .regular)
            label.textColor = theme.Authorization.inputFieldPrimaryColor
            label.textAlignment = .center
            digitView.addSubview(label)
            codeLabels.append(label)
        }
        
        // Tap gesture для активации клавиатуры
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let digitWidth: CGFloat = 50
        let digitHeight: CGFloat = 56
        let spacing: CGFloat = 12
        let totalWidth = CGFloat(codeLength) * digitWidth + CGFloat(codeLength - 1) * spacing
        let startX = (bounds.width - totalWidth) / 2
        
        for (index, digitView) in codeDigitViews.enumerated() {
            let x = startX + CGFloat(index) * (digitWidth + spacing)
            digitView.frame = CGRect(x: x, y: 0, width: digitWidth, height: digitHeight)
            
            if index < codeLabels.count {
                codeLabels[index].frame = digitView.bounds
            }
        }
        
        textField.frame = bounds
    }
    
    @objc private func handleTap() {
        textField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChange() {
        let code = textField.text ?? ""
        
        // Обновляем отображение цифр
        for (index, label) in codeLabels.enumerated() {
            if index < code.count {
                let charIndex = code.index(code.startIndex, offsetBy: index)
                label.text = String(code[charIndex])
                codeDigitViews[index].layer.borderColor = theme.Authorization.accentTextColor.cgColor
            } else {
                label.text = ""
                codeDigitViews[index].layer.borderColor = theme.Authorization.inputFieldStrokeColor.cgColor
            }
        }
        
        textChanged?(code)
    }
    
    func activateInput() {
        textField.becomeFirstResponder()
    }
    
    func clearCode() {
        textField.text = ""
        textFieldDidChange()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Ограничение на длину кода
        return updatedText.count <= codeLength
    }
}

// MARK: - AuthorizationCodeNode (главный экран ввода кода)
// Портировано из AuthorizationSequenceCodeEntryControllerNode.swift

final class AuthorizationCodeNode: UIView {
    
    private let theme: TelegramTheme.Type
    
    // UI Components (из оригинала, строки 22-50)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let animationImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let codeInputView: CodeInputView
    private let errorLabel = UILabel()
    
    private let nextOptionButton = UIButton(type: .system)
    private let resendButton = UIButton(type: .system)
    
    var phoneNumber: String = "" {
        didSet {
            updateDescription()
        }
    }
    
    var email: String?
    
    var currentCode: String {
        return codeInputView.text
    }
    
    // Callbacks (из оригинала, строки 86-96)
    var loginWithCode: ((String) -> Void)?
    var requestNextOption: (() -> Void)?
    var reset: (() -> Void)?
    
    var inProgress: Bool = false {
        didSet {
            codeInputView.alpha = inProgress ? 0.6 : 1.0
            codeInputView.isUserInteractionEnabled = !inProgress
        }
    }
    
    // MARK: - Init
    
    init(theme: TelegramTheme.Type) {
        self.theme = theme
        self.codeInputView = CodeInputView(theme: theme)
        
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup (из оригинала, строки 119-260)
    
    private func setupViews() {
        backgroundColor = theme.Authorization.backgroundColor
        
        // Scroll view
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Animation
        animationImageView.image = UIImage(systemName: "envelope.circle.fill")
        animationImageView.tintColor = theme.Authorization.accentTextColor
        animationImageView.contentMode = .scaleAspectFit
        contentView.addSubview(animationImageView)
        
        // Title (из оригинала, строка 125)
        titleLabel.text = "Enter Code"
        titleLabel.font = .systemFont(ofSize: 30, weight: .light)
        titleLabel.textColor = theme.Authorization.primaryTextColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        // Description (из оригинала, строка 139)
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = theme.Authorization.primaryTextColor
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        // Code input (из оригинала, строка 46)
        codeInputView.textChanged = { [weak self] code in
            self?.errorLabel.isHidden = true
            if code.count == 5 {
                // Автоматически отправляем когда введено 5 цифр
                self?.loginWithCode?(code)
            }
        }
        contentView.addSubview(codeInputView)
        
        // Error label (из оригинала, строка 47)
        errorLabel.font = .systemFont(ofSize: 14, weight: .regular)
        errorLabel.textColor = theme.Authorization.disabledTextColor
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        contentView.addSubview(errorLabel)
        
        // Next option button (из оригинала, строка 31-33)
        nextOptionButton.setTitle("Didn't receive the code?", for: .normal)
        nextOptionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        nextOptionButton.setTitleColor(theme.Authorization.accentTextColor, for: .normal)
        nextOptionButton.addTarget(self, action: #selector(nextOptionTapped), for: .touchUpInside)
        contentView.addSubview(nextOptionButton)
        
        // Resend button (из оригинала, строка 35-36)
        resendButton.setTitle("Resend Code", for: .normal)
        resendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        resendButton.setTitleColor(theme.Authorization.accentTextColor, for: .normal)
        resendButton.addTarget(self, action: #selector(resendTapped), for: .touchUpInside)
        contentView.addSubview(resendButton)
        
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
    
    private func updateDescription() {
        descriptionLabel.text = "We've sent the code to\n\(phoneNumber)"
    }
    
    // MARK: - Layout
    
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
        
        // Description
        descriptionLabel.frame = CGRect(
            x: padding,
            y: offsetY,
            width: contentWidth,
            height: 60
        )
        descriptionLabel.sizeToFit()
        descriptionLabel.frame.size.width = contentWidth
        offsetY += descriptionLabel.frame.height + 32
        
        // Code input
        codeInputView.frame = CGRect(
            x: padding,
            y: offsetY,
            width: contentWidth,
            height: 56
        )
        offsetY += 56 + 16
        
        // Error label
        if !errorLabel.isHidden {
            errorLabel.frame = CGRect(
                x: padding,
                y: offsetY,
                width: contentWidth,
                height: 40
            )
            errorLabel.sizeToFit()
            errorLabel.frame.size.width = contentWidth
            offsetY += errorLabel.frame.height + 8
        }
        
        offsetY += 24
        
        // Next option button
        nextOptionButton.frame = CGRect(
            x: padding,
            y: offsetY,
            width: contentWidth,
            height: 44
        )
        offsetY += 44 + 12
        
        // Resend button
        resendButton.frame = CGRect(
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
    
    @objc private func nextOptionTapped() {
        requestNextOption?()
    }
    
    @objc private func resendTapped() {
        reset?()
    }
    
    // MARK: - Keyboard handling
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets.bottom = keyboardHeight
        
        let codeFrame = codeInputView.frame
        scrollView.scrollRectToVisible(codeFrame, animated: true)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    // MARK: - Public API
    
    func activateInput() {
        codeInputView.activateInput()
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        codeInputView.clearCode()
        setNeedsLayout()
        layoutIfNeeded()
        
        // Shake animation (как в оригинале)
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        codeInputView.layer.add(animation, forKey: "shake")
    }
}
