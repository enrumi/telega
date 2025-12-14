# 📱 MyTelegram - iOS Messenger Clone

A full-featured Telegram clone for iOS with real backend API, built with Swift and Node.js.

[![Build IPA](https://github.com/YOUR_USERNAME/MyTelegramClone/actions/workflows/build-ipa.yml/badge.svg)](https://github.com/YOUR_USERNAME/MyTelegramClone/actions/workflows/build-ipa.yml)

## ✨ Features

### 🔐 Authentication
- Phone number login with 238 countries
- Code verification (always `22222` for demo)
- JWT token authentication
- Secure token storage

### 💬 Messaging
- Real-time chat list
- Send/receive text messages
- Read receipts
- Unread message badges
- Group chat support
- Message timestamps

### 🎨 UI/UX
- 100% Telegram design system
- Exact colors and fonts
- Smooth animations
- Native iOS feel

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Xcode 15+ (for building from source)
- iOS 14+ device or simulator

### Backend Setup

```bash
# Install dependencies
npm install

# Initialize database with test data
npm run init-db

# Start server
npm start
```

Server runs on `http://192.168.1.109:3000`

### iOS App

**Option 1: Download IPA (Releases)**
1. Go to [Releases](https://github.com/YOUR_USERNAME/MyTelegramClone/releases)
2. Download latest `MyTelegramClone-unsigned.ipa`
3. Sideload with AltStore/Sideloadly/TrollStore

**Option 2: Build from Source**
1. Open `MyTelegramClone.xcodeproj` in Xcode
2. Select your device/simulator
3. Press ⌘R to run

### Login

1. Select country (default: Russia +7)
2. Enter any phone number
3. Enter code: `22222`
4. ✅ You're in!

## 📱 Screenshots

(Add screenshots here)

## 🏗️ Architecture

### iOS App
- **UIKit** - Pure UIKit, no SwiftUI
- **MVVM** - Clean architecture
- **URLSession** - Native networking
- **Auto Layout** - Programmatic UI

### Backend
- **Node.js + Express** - REST API
- **SQLite** - Embedded database
- **JWT** - Token authentication
- **240+ countries** - Real phone codes

## 📚 Documentation

- [Quick Start Guide](README_QUICKSTART.md)
- [Backend API Documentation](README_BACKEND.md)
- [iOS App Documentation](README_FRONTEND.md)
- [Icons Setup Guide](README_ICONS.md)

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| iOS UI | UIKit, Swift 5.9+ |
| Networking | URLSession |
| Backend | Node.js, Express |
| Database | SQLite3 |
| Auth | JWT tokens |
| Design | Telegram Design System |

## 📊 Project Structure

```
MyTelegramClone/
├── Network/              # API client
├── Models/              # Data models
├── UI/
│   ├── Authorization/   # Login screens
│   ├── ChatList/       # Chat list
│   ├── Chat/           # Chat screen
│   └── Settings/       # Settings
├── Resources/          # Countries, assets
└── Assets.xcassets/    # Images, icons

Backend/
├── backend_server.js   # Express server
├── init_database.js    # DB setup
└── telegram.db         # SQLite database
```

## 🔧 Configuration

### Change Server IP

Edit `MyTelegramClone/Network/NetworkManager.swift`:

```swift
private let baseURL = "http://YOUR_IP:3000"
```

### Change Authorization Code

Edit `backend_server.js`:

```javascript
if (code !== '22222') {  // Change here
    return res.status(400).json({ error: 'Invalid code' });
}
```

## 🌍 Supported Countries

238 countries with real phone codes from Telegram:
- 🇷🇺 Russia (+7)
- 🇺🇸 USA (+1)
- 🇬🇧 UK (+44)
- 🇩🇪 Germany (+49)
- 🇫🇷 France (+33)
- ...and 233 more

## 📱 Minimum Requirements

- **iOS**: 14.0+
- **Xcode**: 15.0+ (for building)
- **Node.js**: 18.0+ (backend)
- **Network**: Wi-Fi (same network as backend)

## 🐛 Known Issues

- Online status not implemented (requires WebSocket)
- Typing indicator not implemented (requires WebSocket)
- Media messages not supported (text only)
- Voice messages not supported
- Group creation not implemented

## 🤝 Contributing

Contributions are welcome! This is a learning project.

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

Based on Telegram iOS (GPL v2/v3)
Free to use for learning purposes.

## 🙏 Credits

- Original design: Telegram Messenger
- Icons: Telegram iOS app
- Countries list: Telegram iOS resources

## 📞 Support

Issues? Open an issue on GitHub!

---

**Built with ❤️ by reverse engineering Telegram**

🚀 Happy chatting!
