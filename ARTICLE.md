# The Ultimate Guide to `df_log`: Go Beyond `print()` in Flutter

### A beginner-friendly tutorial and complete reference manual for making your Flutter debugging, analytics, and crash reporting smarter.

![](https://raw.githubusercontent.com/dev-cetera/df_log/main/example/example.png)

If you're a Flutter developer, your journey probably started with `print()`. It’s our oldest and most reliable friend for debugging. We sprinkle it everywhere to check a variable's value, confirm a function was called, or see if a widget rebuilt.

But let's be honest. As our apps grow, the console becomes a chaotic wall of white text.

```
Button tapped
Fetching data...
User is null
Network error
UI updated
```

You're left asking: _Which_ button was tapped? _Where_ did the network error happen? This ambiguity is where we waste precious time.

What if your logs could be smart, organized, beautiful, and tell you _exactly_ where they came from? What if they could power your analytics and crash reporting automatically?

Meet **[df_log](https://pub.dev/packages/df_log)**, a simple but profoundly powerful logging package for Dart and Flutter. This guide will take you from a complete beginner to a master of `df_log`, showing you how it will fundamentally change the way you build and debug your apps.

---

### Part 1: Your First Steps - The 5-Minute Upgrade

Let’s get you started. The initial payoff is immediate.

#### Installation

1.  Open your `pubspec.yaml` file.
2.  Add `df_log` to your dependencies:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      df_log: ^latest_version # Check pub.dev for the latest version
    ```

3.  Run `flutter pub get` in your terminal.
4.  Import the package in any Dart file where you want to log:

    ```dart
    import 'package:df_log/df_log.dart';
    ```

#### Your First "Smart" Log

Now, replace a `print()` statement with a `df_log` equivalent.

**Before:**

```dart
print('User successfully authenticated.');
```

**After:**

```dart
Log.ok('User successfully authenticated.');
```

Run your app and look at the console. Instead of plain text, you’ll see something like this:

`🟢 [lib/data/auth_repository.dart:42] User successfully authenticated.`

This is the first "Aha!" moment. You instantly get three upgrades:

1.  **A Category Icon (`🟢`):** You can tell at a glance that this was a success.
2.  **The Exact Location:** You know this log came from `auth_repository.dart` on line `42`. No more guessing! You can click this in most IDEs to jump straight to the code.
3.  **Color:** In supported consoles, the output is beautifully colored, making it easy to scan.

You’ve already saved yourself minutes of future debugging time.

---

### Part 2: The Core Features - Organizing the Chaos

Now let's explore the foundational features that make `df_log` so effective.

#### 1. Semantic Logging: Speaking with Intent

`df_log` provides methods for different kinds of events. This gives your logs meaning.

```dart
void main() {
  Log.start('Application starting...');
  Log.info('Checking for user session...');
  Log.alert('Network connection is slow. Retrying in 5s.');
  Log.ok('User session found and validated.');
  Log.err('Failed to load user preferences!');
  Log.stop('Application shutting down.');
}
```

This turns your console into a readable story of your app's execution, not just a random list of events.

#### 2. Precision Filtering with Tags

This is arguably the most powerful debugging feature. You can assign tags to your logs and then filter the console to show only what you need.

Here’s the golden rule: **A log is only shown if ALL of its tags are currently active.** This `AND` logic allows for surgical precision.

Let’s see it in action.

```dart
// main.dart
void main() {
  // Let's say we only want to debug the UI for the authentication flow.
  Log.addTags({#ui, #auth});

  // ✅ Printed! Has the #auth tag, which is active.
  Log.ok('User logged in.', {#auth});

  // ✅ Printed! Has the #ui tag, which is active.
  Log.info('Rendering profile screen...', {#ui});

  // ❌ NOT Printed! It requires the #network tag, which we haven't activated.
  Log.trace('Fetching user avatar...', {#ui, #network});

  // --- Now, let's debug the network call for the avatar ---
  Log.addTags({#network}); // We add #network to our active set.

  // ✅ Printed! Now all required tags (#ui, #network) are active.
  Log.trace('Fetching user avatar...', {#ui, #network});
}
```

With tags, you can silence the noise from every other part of your app and focus only on the system you're currently working on.

---

### Part 3: The Masterclass - `df_log` as an Application Hub

This is where `df_log` transcends being just a logger. Using callbacks, you can turn it into a central event bus for your entire application.

The `Log.addCallback()` method lets you execute a function every single time a log is created, giving you access to the complete `LogItem` object (message, tags, timestamp, etc.).

#### Use Case 1: Smarter Crash Reporting with Breadcrumbs

When a crash happens, the error message is only half the story. The other half is _what the user did right before it_. `df_log` can automatically provide this context.

```dart
// In your main.dart
void main() {
  // 1. Configure df_log to keep the last 50 log events in memory.
  Log.storeLogs = true;
  Log.maxStoredLogs = 50;

  // 2. Set up a callback for crash reporting.
  Log.addCallback((logItem) {
    // We only care about logs that are tagged as errors.
    if (logItem.tags.contains(#error)) {
      // Get the history of recent events.
      final breadcrumbs = Log.items.map((item) => item.toMap()).toList();

      // Send the error and the breadcrumbs to your reporting service.
      MyCrashReporter.captureException(
        exception: logItem.message,
        extraData: {'log_breadcrumbs': breadcrumbs},
      );
    }
  });

  runApp(MyApp());
}

// Somewhere else in your code...
void updateUserProfile() {
  Log.info('Navigated to profile screen.', {#ui, #profile});
  try {
    // ... code that might fail ...
    throw Exception('Connection timed out');
  } catch (e) {
    // This single line now does two things:
    // 1. Prints a red error to the console for you.
    // 2. Triggers the callback to send a crash report WITH breadcrumbs.
    Log.err('Failed to update profile: $e', {#error, #profile, #network});
  }
}
```

#### Use Case 2: Clean and Centralized Analytics

Stop scattering analytics calls like `FirebaseAnalytics.logEvent()` all over your codebase. Use `df_log` tags to manage them from one central place.

```dart
// In a setup file
void setupAnalytics() {
  Log.addCallback((logItem) {
    if (logItem.tags.contains(#analytics_event)) {
      // The log message can be the event name!
      final eventName = logItem.message.toString();
      MyAnalyticsService.logEvent(name: eventName);
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

If you ever change your analytics provider, you only have to update one callback function, not hundreds of files. Your code becomes cleaner and completely decoupled from the analytics implementation.

---

### Part 4: The Official `df_log` Manual (API Reference)

Here is a quick reference to all the main features available in `df_log`.

#### Main Logging Methods

- `Log.info(message, [tags])`: For general informational messages. (`🟣`)
- `Log.ok(message, [tags])`: For success operations. (`🟢`)
- `Log.err(message, [tags])`: For errors or exceptions. (`🔴`)
- `Log.alert(message, [tags])`: For warnings that need attention. (`🟠`)
- `Log.start(message, [tags])`: To mark the beginning of a process. (`🔵`)
- `Log.stop(message, [tags])`: To mark the end of a process. (`⚫`)
- `Log.trace(message, [tags])`: For fine-grained debugging information. (`⚪️`)
- `Log.printGreen(message)`: Prints a message in a specific color without any other formatting. Many other colors are available (`printRed`, `printYellow`, etc.).

#### Configuration (Static Properties on `Log`)

- `Log.enableStyling = true`: Enables/disables ANSI colors and icons. Set to `false` if your console doesn't support them.
- `Log.showTimestamps = true`: Shows a `HH:mm:ss.SSS` timestamp on each log.
- `Log.showTags = true`: Shows tags like `#auth #ui` on each log.
- `Log.showIds = false`: Shows a unique ID on each log.
- `Log.enableReleaseAsserts = false`: By default, logs only work in debug mode. Set this to `true` to enable logging and asserts in release builds (use with caution).

#### In-Memory Storage

- `Log.storeLogs = true`: If `true`, keeps a history of logs in memory.
- `Log.maxStoredLogs = 1000`: Sets the maximum number of `LogItem` objects to store in the queue.
- `Log.items`: A `Queue<LogItem>` containing the stored logs. You can access it directly to inspect history.

#### Tag Management

- `Log.activeTags`: A `Set<Symbol>` of all currently active tags.
- `Log.addTags(Set<Symbol> tags)`: Adds one or more tags to the active set.
- `Log.removeTags(Set<Symbol> tags)`: Removes tags from the active set.

#### Advanced Features

- `Log.addCallback(callback)`: Registers a function `void Function(LogItem item)` that is called every time a log is created. Returns the callback so you can remove it later.
- `Log.removeCallback(callback)`: Removes a previously registered callback.
- `Log.useDeveloperLog()`: Switches the output to `dart:developer`'s `log` function, which can provide a richer experience in IDEs like VS Code's Debug Console.
- `Log.useStandardPrint()`: Reverts the output to the standard `print` function.

---

### Conclusion

`df_log` is more than just a pretty logger. It's a complete instrumentation framework that encourages you to treat events in your app as structured data. By adopting it, you get:

- **Clarity:** Know exactly where every log comes from.
- **Organization:** Use categories and tags to make your console readable and filterable.
- **Power:** Use callbacks to drive crash reporting, analytics, and performance monitoring from a single, clean source of truth.

It's a small change to your workflow that pays massive dividends in productivity and code quality.

This is an open-source project actively maintained by **[Robert Mollentze](https://github.com/robert-mollentze)** and contributors. If you find it valuable, give the [GitHub repo](https://github.com/dev-cetera/df_log) a star, and consider [buying the author a coffee](https://www.buymeacoffee.com/dev_cetera) to support future development. Happy logging!
