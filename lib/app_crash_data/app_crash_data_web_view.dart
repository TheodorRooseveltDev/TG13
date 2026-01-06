import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app_crash_data.dart';
import 'app_crash_data_parameters.dart';
import 'app_crash_data_service.dart';
import 'app_crash_data_splash.dart';

class AppCrashDataWebViewWidget extends StatefulWidget {
  const AppCrashDataWebViewWidget({super.key});

  @override
  State<AppCrashDataWebViewWidget> createState() =>
      _AppCrashDataWebViewWidgetState();
}

class _AppCrashDataWebViewWidgetState
    extends State<AppCrashDataWebViewWidget>
    with WidgetsBindingObserver {
  InAppWebViewController? appCrashDataWebViewController;

  bool appCrashDataShowLoading = true;

  bool appCrashDataWasOpenNotification =
      appCrashDataSharedPreferences.getBool(
            appCrashDataWasOpenNotificationKey,
          ) ??
          false;

  bool appCrashDataSavePermission =
      appCrashDataSharedPreferences.getBool(
            appCrashDataSavePermissionKey,
          ) ??
          false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    appCrashDataSyncNotificationState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  Future<void> appCrashDataSyncNotificationState() async {
    final bool systemNotificationsEnabled =
        await AppCrashDataService().isSystemPermissionGranted();

    appCrashDataWasOpenNotification = systemNotificationsEnabled;
    appCrashDataSharedPreferences.setBool(
      appCrashDataWasOpenNotificationKey,
      systemNotificationsEnabled,
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> appCrashDataAfterSetting() async {
    final deviceState = OneSignal.User.pushSubscription;

    bool havePermission = deviceState.optedIn ?? false;
    final bool systemNotificationsEnabled =
        await AppCrashDataService().isSystemPermissionGranted();

    if (havePermission || systemNotificationsEnabled) {
      appCrashDataSharedPreferences.setBool(
          appCrashDataWasOpenNotificationKey, true);
      appCrashDataWasOpenNotification = true;
      appCrashDataSharedPreferences
          .setBool(appCrashDataSavePermissionKey, false);
      appCrashDataSavePermission = false;
      AppCrashDataService().sendRequestToBackend();
    }

    setState(() {});
  }

  Future<void> appCrashDataHandlePushPermissionFlow() async {
    await AppCrashDataService().requestPermissionOneSignal();

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
    } else {
      appCrashDataSharedPreferences
          .setBool(appCrashDataSavePermissionKey, true);
      appCrashDataSavePermission = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: appCrashDataShowLoading ? 0 : 1,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: InAppWebView(
                      onCreateWindow: (controller,
                          CreateWindowAction createWindowRequest) async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => _AppCrashDataPopupWebView(
                              windowId: createWindowRequest.windowId,
                              initialRequest: createWindowRequest.request,
                            ),
                          ),
                        );
                        return true;
                      },
                      initialUrlRequest: URLRequest(
                        url: WebUri(appCrashDataLink!),
                      ),
                      initialSettings: InAppWebViewSettings(
                        allowsBackForwardNavigationGestures: false,
                        javaScriptEnabled: true,
                        allowsInlineMediaPlayback: true,
                        mediaPlaybackRequiresUserGesture: false,
                        supportMultipleWindows: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                        cacheEnabled: true,
                        clearCache: false,
                        cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
                        useOnLoadResource: false,
                        useShouldInterceptAjaxRequest: false,
                        useShouldInterceptFetchRequest: false,
                        hardwareAcceleration: true,
                        thirdPartyCookiesEnabled: true,
                        sharedCookiesEnabled: true,
                        disallowOverScroll: true,
                      ),
                      onWebViewCreated: (controller) {
                        appCrashDataWebViewController = controller;
                      },
                      onLoadStop: (controller, url) async {
                        appCrashDataShowLoading = false;
                        setState(() {});
                        if (appCrashDataWasOpenNotification) return;

                        final bool systemNotificationsEnabled =
                            await AppCrashDataService()
                                .isSystemPermissionGranted();

                        await Future.delayed(const Duration(seconds: 3));

                        if (systemNotificationsEnabled) {
                          appCrashDataSharedPreferences.setBool(
                            appCrashDataWasOpenNotificationKey,
                            true,
                          );
                          appCrashDataWasOpenNotification = true;
                          AppCrashDataService().sendRequestToBackend();
                          AppCrashDataService().notifyOneSignalAccepted();
                        }

                        if (!systemNotificationsEnabled) {
                          appCrashDataWasOpenNotification = true;
                          await appCrashDataHandlePushPermissionFlow();
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return appCrashDataBuildWebBottomBar(orientation);
              },
            ),
          ),
        ),
        if (appCrashDataShowLoading)
          const Positioned.fill(
            child: AppCrashDataSplash(),
          ),
      ],
    );
  }

  Widget appCrashDataBuildWebBottomBar(Orientation orientation) {
    return Container(
      color: Colors.black,
      height: orientation == Orientation.portrait ? 25 : 30,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (appCrashDataWebViewController != null &&
                  await appCrashDataWebViewController!.canGoBack()) {
                appCrashDataWebViewController!.goBack();
              }
            },
          ),
          const SizedBox.shrink(),
          IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              if (appCrashDataWebViewController != null &&
                  await appCrashDataWebViewController!.canGoForward()) {
                appCrashDataWebViewController!.goForward();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _AppCrashDataPopupWebView extends StatelessWidget {
  const _AppCrashDataPopupWebView({
    required this.windowId,
    required this.initialRequest,
  });

  final int? windowId;
  final URLRequest? initialRequest;

  @override
  Widget build(BuildContext context) {
    return _AppCrashDataPopupWebViewBody(
      windowId: windowId,
      initialRequest: initialRequest,
    );
  }
}

class _AppCrashDataPopupWebViewBody extends StatefulWidget {
  const _AppCrashDataPopupWebViewBody({
    required this.windowId,
    required this.initialRequest,
  });

  final int? windowId;
  final URLRequest? initialRequest;

  @override
  State<_AppCrashDataPopupWebViewBody> createState() =>
      _AppCrashDataPopupWebViewBodyState();
}

class _AppCrashDataPopupWebViewBodyState
    extends State<_AppCrashDataPopupWebViewBody> {
  InAppWebViewController? popupController;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        foregroundColor: Colors.white,
        toolbarHeight: 36,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: progress < 1 ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: LinearProgressIndicator(
                value: progress < 1 ? progress : null,
                minHeight: 2,
                backgroundColor: Colors.white12,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xff007AFF)),
              ),
            ),
            Expanded(
              child: InAppWebView(
                windowId: widget.windowId,
                initialUrlRequest: widget.initialRequest,
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  supportMultipleWindows: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  allowsInlineMediaPlayback: true,
                ),
                onWebViewCreated: (controller) {
                  popupController = controller;
                },
                onProgressChanged: (controller, newProgress) {
                  setState(() {
                    progress = newProgress / 100;
                  });
                },
                onLoadStop: (controller, uri) {
                  setState(() {
                    progress = 1;
                  });
                },
                onCloseWindow: (controller) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
