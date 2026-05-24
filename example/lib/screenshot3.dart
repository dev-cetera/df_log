import 'package:df_log/df_log.dart';

void main() {
  // Let's say we only want to print logs with #ui and #auth tags.
  Log.activeTags = {#ui, #auth};

  // ✅ Printed! #auth tag got added!
  Log.ok('User logged in.', tags: {#auth});

  // ❌ NOT Printed! #network tag is not added!
  Log.trace('Fetching network info (1)...', tags: {#network});

  // Start printing Logs tagged with #network from here on.
  Log.addTags({#network});

  // ✅ Printed! #network tag got added!
  Log.trace('Fetching network info (2)...', tags: {#network});

  // Stop printing Logs tagged with #network from here on.
  Log.removeTags({#network});

  // ❌ NOT Printed! #network tag got removed!
  Log.trace('Fetching network info (3)...', tags: {#network});
}
