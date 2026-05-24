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
