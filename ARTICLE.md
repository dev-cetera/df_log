## Tired of `print()`? A Pragmatic Guide to Better Logging in Flutter.

### An honest, beginner-friendly look at `df_log` — a package that aims to make your console debugging, analytics, and crash reporting smarter, not just more complicated.

![Screenshot of df_log output in a terminal](https://raw.githubusercontent.com/dev-cetera/df_log/main/example/example.png)

If you're a Flutter developer, your journey started with `print()`. It’s our oldest friend for debugging. We sprinkle it everywhere to check a variable, confirm a function was called, or see if a widget rebuilt.

But as our apps grow, the console becomes a chaotic, colorless waterfall of text.

```
Button tapped
Fetching data...
User is null
Network error
UI updated
```

You're left asking: *Which* button was tapped? *Where* did that network error happen? This ambiguity is where we waste precious time.

Of course, there are powerful, "correct" ways to debug. The **Flutter Debugger** is an incredible tool that lets you pause your app with breakpoints, inspect the entire state, and step through code line by line. For complex bug hunting, it’s unbeatable.

So, why talk about another logging package?

Because sometimes, you don’t want to pause your app. You just want to watch the story of your code unfold in the console. You want the simplicity of `print()` but with more clarity, context, and control. What if your logs could also power your analytics and crash reporting automatically?

Meet **[df_log](https://pub.dev/packages/df_log)**, a pragmatic, opinionated tool designed to do one thing well: **make your console output beautiful, readable, and powerful.**

---

### Part 1: Your First Steps - The 5-Minute Upgrade

The initial payoff is immediate. After adding `df_log` to your `pubspec.yaml` and importing it, you can immediately upgrade your `print()` statements.

#### Your First "Smart" Log

Replace a `print()` statement with a `df_log` equivalent.

**Before:**

```dart
print('User successfully authenticated.');
```

**After:**

```dart
import 'package:df_log/df_log.dart';

Log.ok('User successfully authenticated.');
```

Run your app and look at the console. Instead of plain text, you’ll see something like this:

`🟢 [auth_service/authenticateUser #42] User successfully authenticated.`

This is the first "Aha!" moment. You instantly get three upgrades:

1.  **A Category Icon (`🟢`):** You can tell at a glance that this was a success.
2.  **Precise Context `[filename/member #linenumber]`:** You know exactly where this log came from: the `authenticateUser` function inside the `auth_service.dart` file, on line `42`. No more guessing! You can click this in most IDEs to jump straight to the code.
3.  **Color:** In supported consoles, the output is beautifully colored, making it easy to scan.

You’ve already saved yourself minutes of future debugging time.

---

### Part 2: The Core Features - Organizing the Chaos

Now let's explore the foundational features that make `df_log` so effective.

#### 1. Semantic Logging: Speaking with Intent

`df_log` provides methods for different kinds of events. This gives your logs meaning and turns your console into a readable story of your app's execution.

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

#### 2. Precision Filtering with Tags

This is arguably the most powerful debugging feature. You can assign tags to your logs and then filter the console to show only what you need.

Here’s the golden rule: **A log is only shown if ALL of its tags are currently active.** This `AND` logic allows for surgical precision.

Let’s see it in action.

```dart
// main.dart
void main() {
  // Let's say we only want to debug the UI for the authentication flow.
  Log.activeTags = {#ui, #auth};

  // ✅ Printed! Has the #auth tag, which is active.
  Log.ok('User logged in.', {#auth});

  // ❌ NOT Printed! It requires the #network tag, which we haven't activated yet.
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

The `Log.addCallback()` method lets you execute a function every single time a log is created, giving you access to the complete `LogItem` object.

#### Use Case 1: Smarter Crash Reporting with Breadcrumbs

When a crash happens, the error message is only half the story. The other half is *what the user did right before it*. `df_log` can automatically provide this context.

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

      // Send the error and the breadcrumbs to your reporting service (e.g., Sentry).
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
      // The LogItem can be converted to a map for parameters.
      final parameters = logItem.toMap();
      
      // Send to your service, e.g., Google Analytics / Firebase
      FirebaseAnalytics.instance.logEvent(name: eventName, parameters: parameters);
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

If you ever change your analytics provider, you only have to update **one callback function**, not hundreds of files. Your code becomes cleaner and completely decoupled from the analytics implementation.

---

### Part 4: The `df_log` Manual (Full Feature Set)

Here is a quick reference to all the main features available.

#### Main Logging Methods

-   `Log.info(msg, [tags])`: For general informational messages. (`🟣`)
-   `Log.ok(msg, [tags])`: For success operations. (`🟢`)
-   `Log.err(msg, [tags])`: For errors or exceptions. (`🔴`)
-   `Log.alert(msg, [tags])`: For warnings that need attention. (`🟠`)
-   `Log.start(msg, [tags])`: To mark the beginning of a process. (`🔵`)
-   `Log.stop(msg, [tags])`: To mark the end of a process. (`⚫`)
-   `Log.trace(msg, [tags])`: For fine-grained debugging information. (`⚪️`)
-   `Log.printGreen(message)`: Prints a message in a specific color without any other formatting. Many other colors are available (`printRed`, `printYellow`, `printBlue`, etc.).

#### Configuration (Static Properties on `Log`)

-   `Log.enableStyling = true`: Enables/disables ANSI colors and icons.
-   `Log.showTimestamps = true`: Shows a `HH:mm:ss.SSS` timestamp on each log.
-   `Log.showTags = true`: Shows tags like `#auth #ui` on each log.
-   `Log.showIds = false`: Shows a unique ID on each log.
-   `Log.enableReleaseAsserts = false`: By default, logs only work in debug mode. Set to `true` to enable logging in release builds (use with caution).

#### In-Memory Storage & Callbacks

-   `Log.storeLogs = true`: If `true`, keeps a history of logs in memory.
-   `Log.maxStoredLogs = 1000`: Sets the max number of `LogItem` objects to store.
-   `Log.items`: A `Queue<LogItem>` containing the stored logs.
-   `Log.addCallback(callback)`: Registers a function `void Function(LogItem item)` that runs for every log.
-   `Log.removeCallback(callback)`: Removes a previously registered callback.

#### Advanced Output

-   `Log.useDeveloperLog()`: Switches output to `dart:developer`'s `log` function for a richer experience in some IDEs.
-   `Log.useStandardPrint()`: Reverts the output to the standard `print` function.

---

### Final Thoughts: Is This For You?

Let’s be clear to pre-emptively address the critics. `df_log` is not trying to be the most powerful logging framework in the world.

-   If you need advanced features like log rotation, writing to files, or complex custom formatters, a package like `logger` or `floggy` might be a better choice.
-   If you are deep in a bug and need to inspect object properties and the call stack, **use the Flutter Debugger**. It is the right tool for that job.

So, who is `df_log` for?

It’s for the developer who finds themselves littering their code with `print('--- HERE 1 ---')` and wishes it was just a little bit… better. It’s for adding semantic, colorful, filterable breadcrumbs to trace the flow of an application. It's for centralizing your app's event-based logic, like analytics and crash reporting, through a single, clean API.

The goal is to be **pragmatic**: to provide a massive step up from `print()` without the cognitive overhead of a full-fledged logging framework. It's a simple tool for a common, multifaceted problem.

If that sounds like something that could clean up your debug console and your codebase, give it a try.

This is an open-source project. If you find it valuable, give the [**GitHub repo**](https://github.com/dev-cetera/df_log) a star, and consider [**buying the author a coffee**](https://www.buymeacoffee.com/dev_cetera) to support future development. Happy logging