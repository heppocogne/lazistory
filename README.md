# Lazistory
シンプルなクリップボードの履歴を表示するアプリです。  
コピペは怠惰(Lazy)ですが、美徳でもあります。それと履歴(History)を合わせたアプリ名です。

1週間も掛からないくらいで作ったのでクオリティはお察し下さい。

## ビルドできない時
自動生成された 'package:lazistory/l10n/app_localizations.dart' が見つからず、ビルドが通らない場合があります。  
まず以下のコマンドを実行してください。
```bash
flutter gen-l10n
```
それでもダメなら `flutter clean`, `dart pub cache repair`, `dart pub cache clean`, `dart pub get` などのコマンドを試してから↑のコマンドを実行、エディタを再起動するなどで解消するはずです。

## 今後の目標
* アニメーションを付けたい
