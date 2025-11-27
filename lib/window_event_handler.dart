import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:lazistory/model/app_config.dart';

class WindowEventHandler extends ConsumerStatefulWidget {
  final Widget child;
  const WindowEventHandler({super.key, required this.child});

  @override
  ConsumerState<WindowEventHandler> createState() => _WindowEventHandlerState();
}

class _WindowEventHandlerState extends ConsumerState<WindowEventHandler>
    with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void onWindowClose() async {
    final size = await windowManager.getSize();
    final configNotifier = ref.read(lazistoryAppConfigProvider.notifier);

    configNotifier.setWindowSize(size.width, size.height);
    await configNotifier.save();
    await windowManager.destroy();
  }
}
