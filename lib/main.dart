import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lazistory/window_event_handler.dart';
import 'package:lazistory/model/app_config.dart';
import 'package:lazistory/model/file_location.dart';
import 'package:lazistory/ui/lazistory_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appDocumentsDirectory = await getApplicationDocumentsDirectory();
  debugPrint(appDocumentsDirectory.path);

  await windowManager.ensureInitialized();

  final config = LazistoryAppConfig.load();
  WindowOptions windowOptions = WindowOptions(
    size: Size(config.windowWidth, config.windowHeight),
    minimumSize: const Size(300, 200),
    alwaysOnTop: config.windowAlwaysOnTop,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setTitle('Lazistory');
  });

  runApp(
    const ProviderScope(
      child: WindowEventHandler(
        child: LazistoryApp(),
      ),
    ),
  );
}
