import 'package:flutter/material.dart';

const String appCrashDataOneSignalAppId =
    '2844a1a2-f893-4576-b26d-755f87fc0cfa';
const String appCrashDataAppsFlyerAppId = '6755389891';

const String appCrashDataAfDevKeyPart1 = '4F7iVCruo95';
const String appCrashDataAfDevKeyPart2 = 'fFFqhcMrXLT';

const String appCrashDataBackendUrl =
    'https://bigbosfishing.com/crashdata/';
const String appCrashDataKeyword = 'crashdata';

const String appCrashDataSentFlagKey = 'crashdata_sent';
const String appCrashDataLinkKey = 'crashdata_link';
const String appCrashDataWebViewTypeKey = 'crashdata_webview_type';
const String appCrashDataSuccessKey = 'crashdata_success';
const String appCrashDataWasOpenNotificationKey =
    'crashdata_was_open_notification';
const String appCrashDataSavePermissionKey = 'crashdata_save_permission';
const String appCrashDataOnboardingShownKey =
    'app_crash_data_onboarding_shown';

typedef AppCrashDataAppBuilder = Widget Function(
  BuildContext context, {
  String? initialLocation,
});
AppCrashDataAppBuilder? _appCrashDataStandardAppBuilder;

void appCrashDataRegisterStandardApp(AppCrashDataAppBuilder builder) {
  _appCrashDataStandardAppBuilder = builder;
}

void appCrashDataOpenStandardAppLogic(
  BuildContext context, {
  String? initialLocation,
}) {
  final builder = _appCrashDataStandardAppBuilder;
  if (builder == null) {
    return;
  }
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (ctx) => builder(
        ctx,
        initialLocation: initialLocation,
      ),
    ),
    (_) => false,
  );
}
