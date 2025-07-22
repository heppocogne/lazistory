// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get searchClipboardHistory => 'クリップボード履歴を検索';

  @override
  String get configurations => '設定';

  @override
  String get maxHistoryLength => '最大保存件数';

  @override
  String get keepHistoryUnique => '重複する履歴を削除';

  @override
  String get windowAlwaysOnTop => '常に最前面に表示';

  @override
  String get restorePreviousState => '起動時に前回の状態を復元';

  @override
  String get restoreDefaultConfigurations => '初期設定に戻す';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get clearHistoryContent => 'クリップボード履歴を削除しますか?';

  @override
  String get confirmDeletion => '削除する';

  @override
  String get cancelDeletion => '削除しない';

  @override
  String get historyCleared => 'クリップボード履歴を削除しました';
}
