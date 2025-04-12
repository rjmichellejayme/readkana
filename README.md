# Readka'na

Readka'na is a mobile ebook reader application built using Flutter and local storage. The general objective of the project is to provide users with a reader application that encourages them to engage more in terms of books. It aims to provide a lightweight and efficient digital reading experience by incorporating essential reader tools while leveraging key concepts from mobile development, including state management, database persistence, and UI widgets.

## 🎯 Project Objectives

- Develop a cross-platform mobile reading application using Flutter
- Utilize SQLite for efficient and lightweight local data storage
- Implement state management techniques for dynamic UI updates
- Provide essential features such as bookmarking, text customization, and search functionality
- Ensure smooth navigation using Flutter's built-in routing mechanisms

## 🚀 Core Features

- **Bookmarking & Last Page Memory**
  - Save and retrieve reading progress efficiently using SQLite
  - Automatic last page tracking

- **Custom Themes & Fonts**
  - Light/Dark mode support
  - Font resizing and customization
  - Theme personalization

- **Search & Highlighting**
  - Keyword search functionality
  - Text highlighting capabilities
  - Passage marking

- **Table of Contents Navigation**
  - Easy chapter navigation
  - Quick access to book sections

- **Offline Reading**
  - Local book storage
  - No internet required for reading

- **Library Layout Customization**
  - Grid/list view options
  - Custom book arrangement
  - Personalized library organization

## 🌟 Additional Features

- **Reading Analytics**
  - Reading streak tracking
  - Achievement system
  - Reading statistics (pages read, time spent)

- **Daily Reading Goals**
  - Customizable daily page goals
  - Progress tracking
  - Streak rewards

- **Mood-Based Recommendations**
  - Mood-based book suggestions
  - Personalized reading recommendations

- **Interactive Annotations**
  - Highlight and note-taking
  - Emoji reactions for passages
  - Quick thought capture

- **Reading Environment**
  - Background sounds (Rain, Fireplace, Ocean)
  - Customizable reading atmosphere

- **Quotes & Notes Management**
  - Dedicated quotes section
  - Quick navigation to saved passages
  - Organized book highlights

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Database**: SQLite
- **State Management**: Provider/Bloc (TBD)
- **UI Components**: Material Design 3

## 📋 Prerequisites

Before you begin, ensure you have the following installed:
- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions
- Git

## 🛠️ Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/readkana.git
cd readkana
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📱 Supported Platforms

- Android
- iOS
- Web
- Windows
- macOS
- Linux

## 🏗️ Project Structure

```
readkana/
├── lib/              # Main application code
│   ├── models/       # Data models
│   ├── screens/      # UI screens
│   ├── widgets/      # Reusable widgets
│   ├── services/     # Business logic
│   ├── database/     # SQLite implementation
│   └── utils/        # Helper functions
├── test/             # Test files
├── android/          # Android specific files
├── ios/              # iOS specific files
├── web/              # Web specific files
├── windows/          # Windows specific files
├── macos/            # macOS specific files
├── linux/            # Linux specific files
├── pubspec.yaml      # Project dependencies
└── README.md         # Project documentation
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Code Style

This project follows the [Dart style guide](https://dart.dev/guides/language/effective-dart/style) and uses the following tools:
- Flutter's built-in formatter
- Dart analysis options defined in `analysis_options.yaml`

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- Jayme, RJ Michelle Naffiza
- Pagunsan, Christine Jean

## 📞 Support

For support, please open an issue in the GitHub repository or contact the maintainers.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- CMSC 156 instructors and mentors
- All contributors who have helped shape this project
