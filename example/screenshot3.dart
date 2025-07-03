// ignore_for_file: unused_local_variable

import 'package:df_log/df_log.dart';

void main() {
  // Configure [df_log](https://pub.dev/packages/df_log) to keep the last 50
  // log events in memory.
  Log.maxStoredLogs = 50;

  // Set up a callback for crash reporting.
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

  // runApp(MyApp());

  // Somewhere else in your code...
  updateUserProfile();
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
    Log.err('Failed to update profile: $e', {#profile, #network});
  }
}
