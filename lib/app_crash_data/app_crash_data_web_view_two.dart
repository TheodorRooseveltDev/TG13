import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'app_crash_data.dart';
import 'app_crash_data_parameters.dart';
import 'app_crash_data_service.dart';
import 'app_crash_data_splash.dart';

class AppCrashDataWebViewTwo extends StatefulWidget {
  const AppCrashDataWebViewTwo({super.key, required this.link});

  final String link;

  @override
  State<AppCrashDataWebViewTwo> createState() =>
      _AppCrashDataWebViewTwoState();
}

class _AppCrashDataWebViewTwoState extends State<AppCrashDataWebViewTwo>
    with WidgetsBindingObserver {
  late _AppCrashDataChromeSafariBrowser _browser;
  bool showLoading = true;
  bool appCrashDataWasOpenNotification =
      appCrashDataSharedPreferences.getBool(
            appCrashDataWasOpenNotificationKey,
          ) ??
          false;
  bool appCrashDataSavePermission = appCrashDataSharedPreferences.getBool(
        appCrashDataSavePermissionKey,
      ) ??
      false;
  bool _isOpening = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _browser = _AppCrashDataChromeSafariBrowser(
      onClosedCallback: _handleBrowserClosed,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openBrowser();
    });
  }

  Future<void> _openBrowser() async {
    if (_isOpening || _disposed) return;
    _isOpening = true;
    try {
      await _browser.open(
        url: WebUri(widget.link),
        settings: ChromeSafariBrowserSettings(
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
        ),
      );
      showLoading = false;
      if (mounted) setState(() {});
      if (!appCrashDataWasOpenNotification) {
        await Future.delayed(const Duration(seconds: 3));
        await _handlePushPermissionFlow();
      }
    } finally {
      _isOpening = false;
    }
  }

  void _handleBrowserClosed() {
    if (_disposed) return;
    _isOpening = false;
    showLoading = true;
    if (mounted) setState(() {});
    Future.microtask(() {
      if (_disposed) return;
      _browser = _AppCrashDataChromeSafariBrowser(
        onClosedCallback: _handleBrowserClosed,
      );
      _openBrowser();
    });
  }

  Future<void> _handlePushPermissionFlow() async {
    final bool systemNotificationsEnabled =
        await AppCrashDataService().isSystemPermissionGranted();

    if (systemNotificationsEnabled) {
      appCrashDataSharedPreferences.setBool(
          appCrashDataWasOpenNotificationKey, true);
      appCrashDataWasOpenNotification = true;
      appCrashDataSharedPreferences
          .setBool(appCrashDataSavePermissionKey, false);
      appCrashDataSavePermission = false;
      AppCrashDataService().sendRequestToBackend();
      AppCrashDataService().notifyOneSignalAccepted();
      return;
    }

    await AppCrashDataService().requestPermissionOneSignal();

    final bool systemNotificationsEnabledAfter =
        await AppCrashDataService().isSystemPermissionGranted();

    if (systemNotificationsEnabledAfter) {
      appCrashDataSharedPreferences.setBool(
          appCrashDataWasOpenNotificationKey, true);
      appCrashDataWasOpenNotification = true;
      appCrashDataSharedPreferences
          .setBool(appCrashDataSavePermissionKey, false);
      appCrashDataSavePermission = false;
      AppCrashDataService().sendRequestToBackend();
      AppCrashDataService().notifyOneSignalAccepted();
    } else {
      appCrashDataSharedPreferences
          .setBool(appCrashDataSavePermissionKey, true);
      appCrashDataSavePermission = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: AppCrashDataSplash(),
        ),
        if (showLoading)
          const Positioned.fill(
            child: Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AppCrashDataChromeSafariBrowser extends ChromeSafariBrowser {
  _AppCrashDataChromeSafariBrowser({required this.onClosedCallback});

  final VoidCallback onClosedCallback;

  @override
  void onOpened() {}

  @override
  void onClosed() {
    onClosedCallback();
  }
}
