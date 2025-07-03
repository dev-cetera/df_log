Dart & Flutter Packages by [dev-cetera.com](https://dev-cetera.com) & contributors.

[![pub](https://img.shields.io/pub/v/df_log.svg)](https://pub.dev/packages/df_log)
[![tag](https://img.shields.io/badge/Tag-v0.3.25-purple?logo=github)](https://github.com/dev-cetera/df_log/tree/v0.3.25)

[![buymeacoffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/dev_cetera)
[![sponsor](https://img.shields.io/badge/Sponsor-202020?logo=github-sponsors&logoColor=pink)](https://github.com/sponsors/dev-cetera)
[![patreon](https://img.shields.io/badge/Patreon-202020?logo=patreon)](https://www.patreon.com/RobertMollentze)

[![discord](https://img.shields.io/badge/Discord-5865F2?logo=discord&logoColor=white)](https://discord.gg/gEQ8y2nfyX)
[![instagram](https://img.shields.io/badge/Instagram-E4405F?logo=instagram&logoColor=white)](https://www.instagram.com/dev_cetera/)

[![license](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/dev-cetera/df_log/main/LICENSE)

---

[![banner](https://github.com/dev-cetera/df_log/blob/v0.3.25/doc/assets/banner.png?raw=true)](https://github.com/dev-cetera)

<!-- BEGIN _README_CONTENT -->

`df_log` is a massive upgrade from `print()`. It makes your console output beautiful, readable, and powerful, turning your logs into a central event bus for debugging, analytics, and crash reporting. It’s for the developer who wants the simplicity of `print()` but with more clarity, context, and control.

## ✨ Features

- **Categorized Logging:** Pre-defined methods like `Log.info`, `Log.err`, `Log.ok` for semantic logging.
- **Beautifully Styled Output:** Uses ANSI colors and emojis for clear, readable logs in supported consoles.
- **Tag-Based Filtering:** Assign tags to logs and filter the console output to show only what you need.
- **In-Memory Log Storage:** Keeps a configurable queue of recent logs for debugging or inspection.
- **Release Mode Control:** Configure logs and assertions to be active even in release builds.
- **Customizable Output:** Show or hide timestamps, log IDs, and tags.
- **IDE Integration:** Optionally uses `dart:developer`'s `log` function for a richer experience in some IDEs.
- **Extensible:** Add custom callbacks to integrate with other services (e.g., crash reporting).

## 📸 Screenshot

<img src="https://raw.githubusercontent.com/dev-cetera/df_log/main/doc/assets/example.png" alt="Visual Studio Code Terminal" width="600">

## 🚀 Getting Started

For an introduction, please refer to this article:

- **MEDIUM.COM** [Dart Logging: Your New Best Friend](https://medium.com/@dev-cetera/dart-logging-your-new-best-friend-7e0dbd701dc7)
- **DEV.TO** [Dart Logging: Your New Best Friend](https://dev.to/dev_cetera/dart-logging-your-new-best-friebd-ae1)
- **GITHUB** [Dart Logging: Your New Best Friend](https://github.com/dev-cetera/df_log/blob/main/ARTICLE.md)

## 🧐 Overview

### 💡 1. Categorized Logs

The package comes with a few default log types that you can use creatively.

```dart
import 'package:df_log/df_log.dart';

void main() {
  Log.start('Application starting...');
  Log.info('Checking for user session...');
  Log.alert('Network connection is slow. Retrying in 5s.');
  Log.ok('User session found and validated.');
  Log.err('Failed to load user preferences!');
  Log.stop('Application shutting down.');
}
```

### 💡 2. Colored Logs

Colored logs enhance readability and help you quickly identify different types of messages in the console. By applying distinct colors, you can easily track errors, successes, warnings, and other log types at a glance.

```dart
Log.printRed('This is printed in RED!');
Log.printGreen('This is printed in GREEN!');
Log.printBlue('This is printed in BLUE!');
Log.printYellow('This is printed in YELLOW!');
Log.printCyan('This is printed in CYAN!');
Log.printPurple('This is printed in PURPLE!');
Log.printBlack('This is printed in BLACK!');
Log.printWhite('This is printed in WHITE!');
// and many more...
```

### 💡 3. Tags

Using tags with logs simplifies debugging and organization. Tags allow you to filter logs by including or excluding specific categories, making it easier to focus on relevant information. They can also help categorize data for analytics or other purposes.

```dart
// main.dart
void main() {
  // Only show logs tagged with #auth or #ui.
  Log.addTags({#auth, #ui});

  // Printed!
  Log.info('Initializing UI elements...', {#ui});
  Log.ok('User logged in.', {#auth});
  Log.trace('Connecting to database...', {#auth, #firebase});

  // Not printed -  #db tag doesn't exist!
  Log.trace('Connecting to database...', {#db});

   // Not printed -  #ui exists but #button doesn't!
  Log.trace('Rendering button...', {#ui, #button});

  // Printed!
  Log.addTags({#button});
  Log.trace('Rendering button...', {#ui, #button});
}
```

### 💡 3. Configuration

You can customize the logging behavior to suit your needs, including styling, output format, and storage options. The Log class provides various settings to control how logs are displayed and managed.

```dart
void main() {
   // Enable or disable ANSI colors and icons. Disable this if your console doesn't support it.
  Log.enableStyling = true;

  // Show a timestamp like 'HH:mm:ss.SSS' in the printed output.
  Log.showTimestamps = true;

  // Show tags like '#auth #network' in the printed output.
  Log.showTags = true;

  // Show a unique ID for each log item in the printed output.
  Log.showIds = false;

  // By default, logs only appear in debug mode.
  Log.enableReleaseAsserts = true;

  // Keep a history of logs in memory.
  Log.storeLogs = true;

  // Set the max number of logs to store.
  Log.maxStoredLogs = 500;

  // Use a richer log viewer in supported IDEs (like VS Code's Debug Console).
  Log.useDeveloperLog();

  // Or revert to the standard `print` function.
  Log.useStandardPrint();

  // Add a function to trigger each time a log is added.
  final callback = Log.addCallback((LogItem logItem) {
    final json = logItem.toJson();
    // TODO: Send your log to something like Google Analytics.
  });

  // Remove an existing callback.
  Log.removeCallback(callback);

  runApp(MyApp());
}
```

<!-- END _README_CONTENT -->

---

🔍 For more information, refer to the [API reference](https://pub.dev/documentation/df_log/).

---

## 💬 Contributing and Discussions

This is an open-source project, and we warmly welcome contributions from everyone, regardless of experience level. Whether you're a seasoned developer or just starting out, contributing to this project is a fantastic way to learn, share your knowledge, and make a meaningful impact on the community.

### ☝️ Ways you can contribute

- **Find us on Discord:** Feel free to ask questions and engage with the community here: https://discord.gg/gEQ8y2nfyX.
- **Share your ideas:** Every perspective matters, and your ideas can spark innovation.
- **Help others:** Engage with other users by offering advice, solutions, or troubleshooting assistance.
- **Report bugs:** Help us identify and fix issues to make the project more robust.
- **Suggest improvements or new features:** Your ideas can help shape the future of the project.
- **Help clarify documentation:** Good documentation is key to accessibility. You can make it easier for others to get started by improving or expanding our documentation.
- **Write articles:** Share your knowledge by writing tutorials, guides, or blog posts about your experiences with the project. It's a great way to contribute and help others learn.

No matter how you choose to contribute, your involvement is greatly appreciated and valued!

### ☕ We drink a lot of coffee...

If you're enjoying this package and find it valuable, consider showing your appreciation with a small donation. Every bit helps in supporting future development. You can donate here: https://www.buymeacoffee.com/dev_cetera

<a href="https://www.buymeacoffee.com/dev_cetera" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" height="40"></a>

## LICENSE

This project is released under the [MIT License](https://raw.githubusercontent.com/dev-cetera/df_log/main/LICENSE). See [LICENSE](https://raw.githubusercontent.com/dev-cetera/df_log/main/LICENSE) for more information.
