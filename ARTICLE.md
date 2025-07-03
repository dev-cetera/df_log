
[![banner](https://github.com/dev-cetera/df_log/blob/main/doc/assets/banner.png?raw=true)](https://github.com/dev-cetera)

An honest, beginner-friendly look at df_log - a package that aims to make your console debugging, analytics, and crash reporting smarter, not just more complicated.

---

If you're a Flutter developer, your journey started with `print()`. It's our oldest friend for debugging. We sprinkle it everywhere to check a variable, confirm a function was called, or see if a widget rebuilt.

But as our apps grow, the console becomes a chaotic, colorless waterfall of text.

```
Button tapped
Fetching data...
User is null
Network error
UI updated
```

You're left asking: Which button was tapped? Where did that network error happen? This ambiguity is where we waste precious time.

Of course, there are powerful, "correct" ways to debug. The Flutter Debugger is an incredible tool that lets you pause your app with breakpoints, inspect the entire state, and step through code line by line. For complex bug hunting, it's unbeatable.

So, why talk about another logging package?

Because sometimes, you don't want to pause your app. You just want to watch the story of your code unfold in the console. You want the simplicity of `print()` but with more clarity, context, and control. What if your logs could also power your analytics and crash reporting automatically?

Meet [df_log](https://pub.dev/packages/df_log), a pragmatic, opinionated tool designed to do one thing well: make your console output beautiful, readable, and powerful.

---

## Part 1: Your First Steps - The 5-Minute Upgrade

The initial payoff is immediate. After adding [df_log](https://pub.dev/packages/df_log) to your pubspec.yaml and importing it, you can immediately upgrade your print() statements. Simply replace a `print()` statement with a [df_log](https://pub.dev/packages/df_log) equivalent:

```dart
import 'package:df_log/df_log.dart';

void main() {
  Log.ok('User successfully authenticated.');
}
```

This is what's printed:

![Visual Studio Code Terminal](https://github.com/dev-cetera/df_log/blob/main/doc/assets/screenshot1.png?raw=true)

This is the first "Aha!" moment. You instantly get three upgrades:

- You can tell at a glance that this was a success: The `Log.ok` provides the category icon 🟢 and `#ok` tag.
- You know exactly where this log came from: It came from `example.dart` and within the function main at line`#4`.
- In supported consoles, the output is beautifully colored, making it easy to scan.

You've already saved yourself minutes of future debugging time!

## Part 2: The Core Features - Organizing the Chaos
Now let's explore the foundational features that make [df_log](https://pub.dev/packages/df_log) so effective.

### 1. Semantic Logging: Speaking with Intent

[df_log](https://pub.dev/packages/df_log) provides methods for different kinds of events. This gives your logs meaning and turns your console into a readable story of your app's execution.

```dart
import 'package:df_log/df_log.dart';

void main() {
  Log.start('Application starting...');
  Log.info('Checking for user session...');
  Log.alert('Network connection is slow. Retrying in 5s.');
  Log.ok('User session found and validated.');
  Log.err('Failed to load user preferences!');
  Log.stop('Application shutting down.');
  Log.printRed('This is printed in RED!');
  Log.printGreen('This is printed in GREEN!');
  Log.printBlue('This is printed in BLUE!');
  Log.printYellow('This is printed in YELLOW!');
  Log.printCyan('This is printed in CYAN!');
  Log.printPurple('This is printed in PURPLE!');
  Log.printBlack('This is printed in BLACK!');
  Log.printWhite('This is printed in WHITE!');
}
```

This is what's printed:

![Visual Studio Code Terminal](https://github.com/dev-cetera/df_log/blob/main/doc/assets/screenshot2.png?raw=true)

### 2. Precision Filtering with Tags

You can assign tags to your logs and then filter the console to show only what you need. Let's see it in action.

```dart
import 'package:df_log/df_log.dart';

void main() {
  // Let's say we only want to print logs with #ui and #auth tags.
  Log.activeTags = {#ui, #auth};

  // ✅ Printed! #auth tag got added!
  Log.ok('User logged in.', {#auth});

  // ❌ NOT Printed! #network tag is not added!
  Log.trace('Fetching network info (1)...', {#network});

  // Start printing Logs tagged with #network from here on.
  Log.addTags({#network});

  // ✅ Printed! #network tag got added!
  Log.trace('Fetching network info (2)...', {#network});

  // Stop printing Logs tagged with #network from here on.
  Log.removeTags({#network});

  // ❌ NOT Printed! #network tag got removed!
  Log.trace('Fetching network info (3)...', {#network});
}
```

This is what's printed:

![Visual Studio Code Terminal](https://github.com/dev-cetera/df_log/blob/main/doc/assets/screenshot3.png?raw=true)

As you can see, we can use `Log.activeTags`, `Log.addTags` and `Log.removeTags` to add or remove any tags we like. Typically for debugging, it's best to just specify which tags you want active at the start of your main function.

## Part 3: The Masterclass - Using Callbacks

This is where [df_log](https://pub.dev/packages/df_log) transcends being just a logger. Using callbacks, you can turn it into a central event bus for your entire application.

The `Log.addCallback()` method lets you execute a function every single time a log is created, giving you access to the complete `LogItem` object.

### Use Case 1: Smarter Crash Reporting with Breadcrumbs

When a crash happens, the error message is only half the story. The other half is what the user did right before it. [df_log](https://pub.dev/packages/df_log) can automatically provide this context:

```dart
void main() {
  // 1. Configure [df_log](https://pub.dev/packages/df_log) to keep the last 50 log events in memory.
  Log.maxStoredLogs = 50;

  // 2. Set up a callback for crash reporting.
  Log.addCallback((logItem) {
    // We only care about logs that are tagged as errors.
    if (logItem.tags.contains(#error)) {
      // Get the history of recent events.
      final history = Log.items.map((item) => item.toMap()).toList();
      
      // Compile the payload to send to your crash reporter.
      final payload = {
        'exception': logItem.message,
        'extra': {
          'breadcrumbs': history,
        },
      };

      // TODO: Send the payload to your crash reporter here!
    }
  });

  runApp(MyApp());
}

// Somewhere else in your code...
void updateUserProfile() {
  Log.info('Navigated to profile screen.', {#ui, #profile});
  try {
    // Do stuff...
    throw Exception('Connection timed out');
  } catch (e) {
    // This single line now does two things:
    // 1. Prints the error to the console for you.
    // 2. Triggers the callback to send a crash report WITH breadcrumbs.
    Log.err('Failed to update profile: $e', {#error, #profile, #network});
  }
}
```
The `LogItem.toMap()` or `LogItem.toJson()` function will output detailed information about the log, including a unique id, a timestamp and more:

```json
{
  "icon": "🟣",
  "location": "example/updateUserProfile #32",
  "message": "Navigated to profile screen.",
  "timestamp": "2025-07-03T04:03:39.517345",
  "tags": [
    "ui",
    "profile",
    "info"
  ],
  "id": "186abf74-6ace-40ec-89f5-90edce1fb48c",
  "column": 7,
  "line": 32,
  "package": null,
  "library": "example/example.dart",
  "uri": "file:///Users/robmllze/Projects/flutter/dev_cetera/df_packages/packages/df_log/example/example.dart"
}
{
  "icon": "🔴",
  "location": "example/updateUserProfile #39",
  "message": "Failed to update profile: Exception: Connection timed out",
  "timestamp": "2025-07-03T04:03:39.521080",
  "tags": [
    "error",
    "profile",
    "network"
  ],
  "id": "b465efdd-1add-4f39-843c-ab98e55dc18b",
  "column": 9,
  "line": 39,
  "package": null,
  "library": "example/example.dart",
  "uri": "file:///Users/robmllze/Projects/flutter/dev_cetera/df_packages/packages/df_log/example/example.dart"
}
```

### Use Case 2: Clean and Centralized Analytics

Stop scattering analytics calls like `FirebaseAnalytics.logEvent()` all over your codebase. Use [df_log](https://pub.dev/packages/df_log) tags to manage them from one central place.

```dart
// In a setup file.
void setupAnalytics() {
  Log.addCallback((logItem) {
    // Capture logs tagged with #analytics_event only!
    if (logItem.tags.contains(#analytics_event)) {
      // The log message can be the event name.
      final name = logItem.message.toString();
      
      // The LogItem can be converted to a map for parameters.
      final parameters = logItem.toMap();
      
      // Send to your service, e.g., Google/Firebase Analytics.
      FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: parameters,
      );
    }
  });
}

// In your UI code, logging IS your analytics:
void onPurchaseButtonPressed() {
  // ... process payment ...

  // This log now sends an event to your analytics provider.
  Log.ok('purchase_complete', {#analytics_event});
}
```

## Part 4: The Full Feature Set

Here is a quick reference to all the main features available.

### Main Logging Methods

Log.info(msg, [tags]): For general informational messages. (🟣)
Log.ok(msg, [tags]): For success operations. (🟢)
Log.err(msg, [tags]): For errors or exceptions. (🔴)
Log.alert(msg, [tags]): For warnings that need attention. (🟠)
Log.start(msg, [tags]): To mark the beginning of a process. (🔵)
Log.stop(msg, [tags]): To mark the end of a process. (⚫)
Log.trace(msg, [tags]): For fine-grained debugging information. (⚪️)
Log.printGreen(message): Prints a message in a specific color without any other formatting. Many other colors are available (printRed, printYellow, printBlue, etc.).

### Configuration (Static Properties on Log)

Log.enableStyling = true: Enables/disables ANSI colors and icons. Set this to false if your terminal does not supprt ANSI colors.
Log.showTimestamps = true: Shows a HH:mm:ss.SSS timestamp on each log.
Log.showTags = true: Shows tags like #auth #ui on each log.
Log.showIds = false: Shows a unique ID on each log.
Log.enableReleaseAsserts = false: By default, logs only work in debug mode. Set to true to enable logging in release builds (use with caution).

### In-Memory Storage & Callbacks

Log.storeLogs = true: If true, keeps a history of logs in memory.
Log.maxStoredLogs = 50: Sets the max number of LogItem objects to store.
Log.items: A Queue<LogItem> containing the stored logs.
Log.addCallback(callback): Registers a function void Function(LogItem item) that runs for every log.
Log.removeCallback(callback): Removes a previously registered callback.

### Advanced Output

Log.useDeveloperLog(): Switches output to dart:developer's log function for a richer experience in some IDEs.
Log.useStandardPrint(): Reverts the output to the standard print function.

---

## Final Thoughts: Is This For You?

[df_log](https://pub.dev/packages/df_log) is for the developer who finds themselves littering their code with `print('--- HERE 1 ---')` and wishes it was just a little bit… better.

It's for adding semantic, colorful, filterable breadcrumbs to trace the flow of an application. It's for centralizing your app's event-based logic, like analytics and crash reporting, through a single, clean API.

The goal is to be pragmatic: to provide a massive step up from `print()` without the cognitive overhead of a full-fledged logging framework. It's a simple tool for a common, multifaceted problem.

If that sounds like something that could clean up your debug console and your codebase, give it a try.

To begin leveraging smarter logging in your Flutter projects, explore the [df_log](https://pub.dev/packages/df_log) package on pub.dev.