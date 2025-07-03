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

## 🚀 Getting Started

For an introduction, please refer to this article:

- **MEDIUM.COM** [Dart Logging: Your New Best Friend](https://medium.com/@dev-cetera/dart-logging-your-new-best-friend-7e0dbd701dc7)
- **DEV.TO** [Dart Logging: Your New Best Friend](https://dev.to/dev_cetera/dart-logging-your-new-best-friebd-ae1)
- **GITHUB** [Dart Logging: Your New Best Friend](https://github.com/dev-cetera/df_log/blob/main/ARTICLE.md)


## 📖 Usage

<img src="https://raw.githubusercontent.com/dev-cetera/df_log/main/doc/assets/screenshot2.png" alt="Visual Studio Code Terminal" width="600">

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