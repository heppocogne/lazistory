// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get searchClipboardHistory => 'Search clipboard History';

  @override
  String get configurations => 'Configurations';

  @override
  String get maxHistoryLength => 'Max list length';

  @override
  String get keepHistoryUnique => 'Unique list items';

  @override
  String get windowAlwaysOnTop => 'Always on top';

  @override
  String get restorePreviousState => 'Restore previous state';

  @override
  String get restoreDefaultConfigurations => 'Reset to default';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get clearHistoryContent =>
      'Would you want to clear the clipboard history?';

  @override
  String get confirmDeletion => 'Delete';

  @override
  String get cancelDeletion => 'Cancel';

  @override
  String get historyCleared => 'Clipboard history are cleared';
}
