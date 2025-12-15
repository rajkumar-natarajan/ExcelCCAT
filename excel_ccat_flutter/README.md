# ExcelCCAT Flutter App

A cross-platform Flutter application for CCAT (Canadian Cognitive Abilities Test) preparation, supporting iOS, Android, Web, and macOS.

## Features

*   **Cross-Platform Support**: Runs seamlessly on mobile (iOS/Android), desktop (macOS), and web.
*   **Comprehensive Question Bank**: Covers Levels K, 10, 11, and 12 (Grades K-12).
*   **Three Main Batteries**:
    *   **Verbal**: Analogies, Sentence Completion, Classification.
    *   **Quantitative**: Number Analogies, Number Series, Quantitative Relations.
    *   **Non-Verbal**: Figure Matrices, Figure Classification, Figure Series (Text-based logic puzzles in this version).
*   **Test Modes**:
    *   **Quick Assessment**: 20 questions, 10 minutes.
    *   **Standard Practice**: 50 questions, 30 minutes.
    *   **Full Mock Test**: 176 questions, 90 minutes.
*   **Progress Tracking**: Detailed analytics of performance by question type.
*   **Bilingual Support**: English and French (Structure ready).

## Getting Started

### Prerequisites
*   Flutter SDK (3.10.0 or higher)
*   Dart SDK
*   Xcode (for iOS/macOS)
*   Android Studio (for Android)

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/yourusername/excel_ccat_flutter.git
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the app:
    ```bash
    # For macOS
    flutter run -d macos

    # For Web
    flutter run -d chrome
    ```

## Project Structure

*   `lib/models`: Data models for Questions, Test Configurations, and Results.
*   `lib/data`: `QuestionDataManager` handles question generation and logic.
*   `lib/screens`: UI screens for Dashboard, Practice, Test Session, and Results.
*   `test`: Integration and Unit tests.

## Note on Non-Verbal Questions
In this version, Non-Verbal questions (Figure Matrices, Classification, Series) are implemented as **text-based logic puzzles** to demonstrate the logic without requiring external image assets. Future updates will include graphical assets for these sections.
