<a href="https://www.buymeacoffee.com/dev_cetera" target="_blank"><img align="right" src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

Dart & Flutter Packages by dev-cetera.com & contributors.

[![pub package](https://img.shields.io/pub/v/df_log.svg)](https://pub.dev/packages/df_log)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/dev-cetera/df_log/main/LICENSE)

## Summary

A package that provides a simple, powerful, and beautiful logging utility for better debugging in Dart and Flutter. For a full feature set, please refer to the [API reference](https://pub.dev/documentation/df_log/latest/).

## Features

- **Categorized Logging:** Pre-defined methods like `Log.info`, `Log.err`, `Log.ok` for semantic logging.
- **Beautifully Styled Output:** Uses ANSI colors and emojis for clear, readable logs in supported consoles.
- **Tag-Based Filtering:** Assign tags to logs and filter the console output to show only what you need.
- **In-Memory Log Storage:** Keeps a configurable queue of recent logs for debugging or inspection.
- **Release Mode Control:** Configure logs and assertions to be active even in release builds.
- **Customizable Output:** Show or hide timestamps, log IDs, and tags.
- **IDE Integration:** Optionally uses `dart:developer`'s `log` function for a richer experience in some IDEs.
- **Extensible:** Add custom callbacks to integrate with other services (e.g., crash reporting).

## Screenshot

<img src="https://raw.githubusercontent.com/dev-cetera/df_log/main/example/example.png" alt="Example image" width="400">

## Usage

### 1. Categorized Logs

```dart
import 'package:df_log/df_log.dart';

void main() {
  Log.start('Application starting...');
  Log.info('This is an informational message.');
  Log.ok('User successfully authenticated.');
  Log.alert('Network connection is slow.');
  Log.err('Failed to load user data!');
  Log.stop('Application shutting down.');
}
```

### 2. Colored Logs

```dart
Log.printRed('This is an important error.');
Log.printGreen('Operation was successful.');
Log.printYellow('This is a warning.');
```

### 2. Colored Logs

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

### 3. Configuration

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

## Contributing and Discussions

This is an open-source project, and we warmly welcome contributions from everyone, regardless of experience level. Whether you're a seasoned developer or just starting out, contributing to this project is a fantastic way to learn, share your knowledge, and make a meaningful impact on the community.

### Ways you can contribute:

- **Buy me a coffee:** If you'd like to support the project financially, consider [buying me a coffee](https://www.buymeacoffee.com/dev_cetera). Your support helps cover the costs of development and keeps the project growing.
- **Share your ideas:** Every perspective matters, and your ideas can spark innovation.
- **Report bugs:** Help us identify and fix issues to make the project more robust.
- **Suggest improvements or new features:** Your ideas can help shape the future of the project.
- **Help clarify documentation:** Good documentation is key to accessibility. You can make it easier for others to get started by improving or expanding our documentation.
- **Write articles:** Share your knowledge by writing tutorials, guides, or blog posts about your experiences with the project. It's a great way to contribute and help others learn.

No matter how you choose to contribute, your involvement is greatly appreciated and valued!

### Discord Server

Feel free to ask questions and engage with the community here: https://discord.gg/gEQ8y2nfyX

## Chief Maintainer:

📧 Email _Robert Mollentze_ at robmllze@gmail.com

## Dontations:

If you're enjoying this package and find it valuable, consider showing your appreciation with a small donation. Every bit helps in supporting future development. You can donate here:

https://www.buymeacoffee.com/dev_cetera

## License

This project is released under the MIT License. See [LICENSE](https://raw.githubusercontent.com/dev-cetera/df_log/main/LICENSE) for more information.
