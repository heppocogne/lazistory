import 'dart:io';
import 'package:toml/toml.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lazistory/model/file_location.dart';

class LazistoryAppConfig {
  static final configFilePath = '${appDocumentsDirectory.path}/config.toml';

  final int _formatVersion = 0;
  int maxHistoryLength = 20;
  bool keepHistoryUnique = true;
  bool windowAlwaysOnTop = true;
  bool restorePreviousState = true;
  double windowWidth = 1280.0;
  double windowHeight = 720.0;

  LazistoryAppConfig();

  LazistoryAppConfig.withValues(
    this.maxHistoryLength,
    this.keepHistoryUnique,
    this.windowAlwaysOnTop,
    this.restorePreviousState,
    this.windowWidth,
    this.windowHeight,
  );

  static LazistoryAppConfig load() {
    final file = File(configFilePath);
    if (file.existsSync()) {
      final String toml = file.readAsStringSync();
      final doc = TomlDocument.parse(toml);
      var config = doc.toMap();
      if (config['FormatVersion'] == 0) {
        return LazistoryAppConfig.withValues(
          config['MaxHistoryLength'],
          config['HideDuplicatedHistory'],
          config['WindowAlwaysOnTop'],
          config['RestorePreviousState'],
          config['WindowWidth'] ?? 1280.0,
          config['WindowHeight'] ?? 720.0,
        );
      }
    }
    return LazistoryAppConfig();
  }

  LazistoryAppConfig copyWith({
    int? maxHistoryLength,
    bool? keepHistoryUnique,
    bool? windowAlwaysOnTop,
    bool? restorePreviousState,
    double? windowWidth,
    double? windowHeight,
  }) {
    return LazistoryAppConfig.withValues(
      maxHistoryLength ?? this.maxHistoryLength,
      keepHistoryUnique ?? this.keepHistoryUnique,
      windowAlwaysOnTop ?? this.windowAlwaysOnTop,
      restorePreviousState ?? this.restorePreviousState,
      windowWidth ?? this.windowWidth,
      windowHeight ?? this.windowHeight,
    );
  }

  Future<void> saveConfig() async {
    Map<String, dynamic> map = {
      'FormatVersion': _formatVersion,
      'MaxHistoryLength': maxHistoryLength,
      'HideDuplicatedHistory': keepHistoryUnique,
      'WindowAlwaysOnTop': windowAlwaysOnTop,
      'RestorePreviousState': restorePreviousState,
      'WindowWidth': windowWidth,
      'WindowHeight': windowHeight,
    };

    var doc = TomlDocument.fromMap(map);
    final file = File(LazistoryAppConfig.configFilePath);
    await file.writeAsString(doc.toString());
  }
}

class ConfigStateNotifier extends StateNotifier<LazistoryAppConfig> {
  ConfigStateNotifier(super.state);

  void setMaxHistoryLength(int value) {
    state = state.copyWith(maxHistoryLength: value);
  }

  void setKeepHistoryUnique(bool value) {
    state = state.copyWith(keepHistoryUnique: value);
  }

  void setWindowAlwaysOnTop(bool value) {
    state = state.copyWith(windowAlwaysOnTop: value);
  }

  void setRestorePreviousState(bool value) {
    state = state.copyWith(restorePreviousState: value);
  }

  void setWindowSize(double width, double height) {
    state = state.copyWith(windowWidth: width, windowHeight: height);
  }

  void setConfig(LazistoryAppConfig config) {
    state = config;
  }

  Future<void> save() async {
    await state.saveConfig();
  }
}

final lazistoryAppConfigProvider =
    StateNotifierProvider<ConfigStateNotifier, LazistoryAppConfig>((ref) {
  return ConfigStateNotifier(LazistoryAppConfig.load());
});
