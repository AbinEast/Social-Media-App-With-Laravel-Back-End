# Flutter Social Media App

A modern and fully functional Social Media App UI kit built with **Flutter**. This project demonstrates a clean architecture and responsive design, featuring essential social networking functionalities like Reels, Stories, Chat, and Post creation.

## Features

This app includes a variety of screens and features common in top-tier social media platforms:

* **Authentication**: Sign In, Create Account, and Forgot Password screens.
* **Home Feed**: Scrollable feed showing user posts, likes, and comments.
* **Reels**: Full-screen video scrolling interface similar to TikTok or Instagram Reels.
* **Stories**: Story view interface for sharing moments.
* **Real-time Chat**:
    * **Chat List**: View all recent conversations.
    * **Chat Details**: Individual chat interface for messaging.
* **User Profile**:
    * Profile details (Bio, Followers, Following).
    * Edit Profile functionality.
    * Grid view of user posts.
* **Create Post**: dedicated interface for uploading new content.
* **Search & Explore**: Discover new users and content.
* **Notifications**: Activity feed for likes, comments, and follows.

## Project Structure

The project is organized for scalability and maintainability:

```text
lib/
├── pages/
│   ├── home_page.dart           # Main feed
│   ├── profile_page.dart        # User profile
│   ├── chat_list_page.dart      # Messages list
│   ├── chat_detail_page.dart    # Chat room
│   ├── reels_page.dart          # Video reels
│   ├── create_post_page.dart    # Upload post
│   ├── search_page.dart         # Search users/tags
│   ├── notifications_page.dart  # Activity feed
│   ├── sign_in_screen.dart      # Login
│   ├── create_account_screen.dart # Registration
│   └── ...
├── widgets/
│   ├── reel_item.dart           # Reusable reel component
│   └── ...
└── main.dart                    # App entry point
```

## Getting Started
Follow these steps to run the project locally.
Prerequisites :

  - Flutter SDK installed.

  - Android Studio or VS Code with Flutter extensions.

  - An Android Emulator or iOS Simulator.

Installation :
- Clone the repository (or innstall the zip)
```
git clone [https://github.com/your-username/Flutter-Social-Media-App.git](https://github.com/your-username/Flutter-Social-Media-App.git)
cd Flutter-Social-Media-App
```

- Install dependencies
```
flutter pub get
```

- run the app
```
flutter run
```
