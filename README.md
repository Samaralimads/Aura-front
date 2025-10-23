# Aura (Frontend iOS)
**Mobile Client for Mental Wellbeing**
---
## 📖 About
Aura is an iOS mobile application designed to help users improve their mental wellbeing through:
- **Mood tracking** (daily journal, emotion analysis)
- **Guided meditation and breathing exercises**
- **Personal challenges and reward system**
- **Sleep tracking and improvement tips**

This repository contains the **SwiftUI-based frontend** for the Aura ecosystem, communicating with the [Aura Backend API](https://github.com/Samaralimads/Aura-back).

---
## 🛠 Technologies
- **Framework**: [SwiftUI](https://developer.apple.com/xcode/swiftui/) (iOS 15+)
- **Language**: Swift 5.7+
- **State Management**: MVVM (Model-View-ViewModel)
- **Networking**: URLSession + Combine
- **Authentication**: JWT (via UserDefault)
- **Dependency Management**: Swift Package Manager

---
## 📂 Project Structure
```
Aura-front/
├── Aura/                # Main app module
│   ├── Assets.xcassets/ # App icons, images, and colors
│   ├── Models/           # Data models (Mood, Challenge, User, etc.)
│   ├── ViewModels/       # ViewModels for MVVM
│   ├── Views/            # SwiftUI views (screens, components)
│   ├── Services/         # Network services, API clients
│   ├── Utilities/        # Helpers, extensions, constants
│   ├── App.swift         # Main app entry
│   └── Preview Content/  # SwiftUI preview data
├── Aura.xcodeproj/       # Xcode project file
├── AuraTests/            # Unit and UI tests
├── LICENSE
└── README.md
```
---
### 📦 Installation
1. **Clone the repository**:
   ```bash
   git clone https://github.com/Samaralimads/Aura-front
---
## 👥 Contributors
- [@Alitchoum](https://github.com/Alitchoum)
- [@chabane23](https://github.com/chabane23)
- [@mlegoul](https://github.com/mlegoul)
- [@Samaralimads](https://github.com/Samaralimads)
---
## 📄 License
This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.