import UIKit

// MARK: - Экран чата с сообщениями (1:1 с Telegram)
class ChatViewController: UIViewController {
    
    private let chat: Chat
    private var messages: [Message] = []
    private var isLoading = false
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = TelegramTheme.Chat.backgroundColor
        table.separatorStyle = .none
        table.allowsSelection = false
        table.keyboardDismissMode = .interactive
        table.delegate = self
        table.dataSource = self
        table.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseIdentifier)
        table.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        table.translatesAutoresizingMaskIntoConstraints = false
        // Инвертируем таблицу для правильной прокрутки снизу вверх
        table.transform = CGAffineTransform(scaleX: 1, y: -1)
        return table
    }()
    
    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = TelegramTheme.Chat.inputBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let inputTopBorder: UIView = {
        let view = UIView()
        view.backgroundColor = TelegramTheme.Chat.inputPanelSeparatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = TelegramFonts.inputText
        textView.textColor = TelegramTheme.Chat.inputFieldTextColor
        textView.backgroundColor = TelegramTheme.Chat.inputFieldBackgroundColor
        textView.layer.cornerRadius = 18
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Message"
        label.font = TelegramFonts.inputPlaceholder
        label.textColor = TelegramTheme.Chat.inputFieldPlaceholderColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.tintColor = TelegramTheme.Chat.sendButtonColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var inputContainerBottomConstraint: NSLayoutConstraint!
    private var inputTextViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    
    init(chat: Chat) {
        self.chat = chat
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
        
        inputTextView.delegate = self
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = TelegramTheme.Chat.backgroundColor
        
        view.addSubview(tableView)
        view.addSubview(inputContainerView)
        view.addSubview(activityIndicator)
        
        inputContainerView.addSubview(inputTopBorder)
        inputContainerView.addSubview(inputTextView)
        inputContainerView.addSubview(sendButton)
        inputTextView.addSubview(placeholderLabel)
        
        inputContainerBottomConstraint = inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        inputTextViewHeightConstraint = inputTextView.heightAnchor.constraint(equalToConstant: 36)
        
        NSLayoutConstraint.activate([
            // TableView
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),
            
            // Input Container
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerBottomConstraint,
            
            // Top Border
            inputTopBorder.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            inputTopBorder.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            inputTopBorder.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            inputTopBorder.heightAnchor.constraint(equalToConstant: 0.5),
            
            // Input TextView
            inputTextView.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 8),
            inputTextView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 8),
            inputTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            inputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            inputTextViewHeightConstraint,
            
            // Placeholder
            placeholderLabel.topAnchor.constraint(equalTo: inputTextView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: inputTextView.leadingAnchor, constant: 16),
            
            // Send Button
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -8),
            sendButton.bottomAnchor.constraint(equalTo: inputTextView.bottomAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 36),
            sendButton.heightAnchor.constraint(equalToConstant: 36),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        updateSendButtonState()
    }
    
    private func setupNavigationBar() {
        title = chat.title
        
        navigationController?.navigationBar.tintColor = TelegramTheme.NavigationBar.buttonColor
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Кнопка с аватаром и онлайн-статусом (упрощенная версия)
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(infoButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightButton
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
    
    // MARK: - Data Loading
    
    private func loadMessages() {
        guard !isLoading else { return }
        
        isLoading = true
        activityIndicator.startAnimating()
        
        Task {
            do {
                let fetchedMessages = try await NetworkManager.shared.fetchMessages(chatId: chat.id)
                
                await MainActor.run {
                    self.messages = fetchedMessages.reversed() // Инвертируем для правильного отображения
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.isLoading = false
                    
                    print("✅ Загружено сообщений: \(fetchedMessages.count)")
                }
            } catch {
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.isLoading = false
                    
                    print("❌ Ошибка загрузки сообщений: \(error)")
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func sendButtonTapped() {
        guard let text = inputTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else { return }
        
        print("📤 Отправка сообщения: \(text)")
        
        inputTextView.text = ""
        placeholderLabel.isHidden = false
        updateSendButtonState()
        
        Task {
            do {
                let messageId = try await NetworkManager.shared.sendMessage(chatId: chat.id, text: text)
                
                await MainActor.run {
                    print("✅ Сообщение отправлено: id=\(messageId)")
                    
                    // Перезагружаем сообщения с сервера для актуальных данных
                    self.loadMessages()
                }
            } catch {
                await MainActor.run {
                    print("❌ Ошибка отправки сообщения: \(error)")
                    
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Failed to send message. Please try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func infoButtonTapped() {
        print("ℹ️ Info button tapped")
        
        let alert = UIAlertController(
            title: chat.title,
            message: "Chat info screen not implemented",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        inputContainerBottomConstraint.constant = -keyboardFrame.height
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        inputContainerBottomConstraint.constant = 0
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateSendButtonState() {
        let hasText = !(inputTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        sendButton.isEnabled = hasText
        sendButton.tintColor = hasText ? TelegramTheme.Chat.sendButtonColor : TelegramTheme.Chat.sendButtonDisabledColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseIdentifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.configure(with: message)
        // Инвертируем ячейку обратно
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITextViewDelegate
extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        updateSendButtonState()
        
        // Динамическая высота (макс 120)
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .infinity))
        let newHeight = min(120, max(36, size.height))
        inputTextViewHeightConstraint.constant = newHeight
    }
}
