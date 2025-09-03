import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/src/common/index.dart';

class AppLoading {
  AppLoading._internal();

  static final _singleton = AppLoading._internal();
  factory AppLoading() => _singleton;

  final Debouncer _debouncer = Debouncer(duration: const Duration(seconds: 15));

  static void show({
    Duration timeout = const Duration(seconds: 15),
    VoidCallback? onTimeout,
  }) =>
      _singleton._show(timeout: timeout, onTimeout: onTimeout);
  static void hide() => _singleton._hide();

  void _show({
    required Duration timeout,
    VoidCallback? onTimeout,
  }) {
    if (EasyLoading.isShow) EasyLoading.dismiss();

    _debouncer.call(() {
      _hide();
      debugPrint('⚠️ Loading auto dismissed after 15 seconds');
      onTimeout?.call();
    });
    EasyLoading.show();
  }

  void _hide() {
    if (EasyLoading.isShow) {
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        EasyLoading.dismiss();
      });
    }

    _debouncer.dispose();
  }
}
