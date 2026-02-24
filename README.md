# Math Rush 🚀

Math Rush is a fast-paced, high-intensity mental math game built with Flutter. Challenge your brain with quick-fire arithmetic and logic puzzles designed to push your cognitive speed to the limit!

## ✨ Features

- **Dynamic Game Modes**: Switch between 5 different types of challenges including:
  - **Comparison**: Rapidly identify which number is greater or lower.
  - **Even/Odd**: Quick classification of numbers.
  - **Prime Check**: Identify prime numbers under pressure.
  - **Math Trap**: Spot arithmetic errors in a split second.
  - **Pattern Break**: Complete the sequence before time runs out.
- **Increasing Difficulty**: The game scales as you score higher, reducing the timer and increasing the complexity of the questions.
- **Modern Pastel UI**: A beautiful, vibrant aesthetic featuring a signature coral theme and smooth "frosted glass" glassmorphism effects.
- **Revive System**: Don't let a single mistake end your run. Use rewarded ads to revive and continue your streak.
- **Persistent High Scores**: Track your progress and try to beat your personal best.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [GetX](https://pub.dev/packages/get) (Clean architecture with Controllers, Bindings, and Services).
- **Ads Integration**: [Google Mobile Ads](https://pub.dev/packages/google_mobile_ads) (Banner, Interstitial, and Rewarded).
- **Local Storage**: [SharedPreferences](https://pub.dev/packages/shared_preferences) for high-score persistence.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Android Studio / Xcode
- AdMob Account (or use test IDs provided in `AdHelper`)

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/math_rush.git
   cd math_rush
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 🏗 Project Structure

- `lib/core`: Core utilities, constants, services (AdService), and global widgets (BannerAdWidget).
- `lib/data`: Data models and providers.
- `lib/features`: Feature-based modules (Home, Game) containing controllers, bindings, and views.
- `lib/features/game/logic`: The procedural generation engine for math puzzles.
