import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lazistory/ui/lazistory_app.dart';
import 'package:lazistory/model/app_config.dart';
import 'package:lazistory/model/file_location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appDocumentsDirectory = await getApplicationDocumentsDirectory();
  debugPrint(appDocumentsDirectory.path);

  WindowManager.instance.ensureInitialized().then((_) {
    WindowManager.instance.setTitle('Lazistory');
    WindowManager.instance.setMinimumSize(const Size(300, 200));
    final config = LazistoryAppConfig.load();
    WindowManager.instance.setAlwaysOnTop(config.windowAlwaysOnTop);
  });

  runApp(
    const ProviderScope(
      child: LazistoryApp(),
    ),
  );
}
