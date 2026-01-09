import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_crash_data_parameters.dart';
import 'app_crash_data_service.dart';
import 'app_crash_data_splash.dart';

late SharedPreferences appCrashDataSharedPreferences;

dynamic appCrashDataConversionData;
String? appCrashDataTrackingPermissionStatus;
String? appCrashDataAdvertisingId;
String? appCrashDataLink;

String? appCrashDataAppsflyerId;
String? appCrashDataExternalId;

int appCrashDataWebViewType = 1;
bool appCrashDataConversionHandled = false;

class AppCrashData extends StatefulWidget {
  const AppCrashData({super.key});

  @override
  State<AppCrashData> createState() => _AppCrashDataState();
}

class _AppCrashDataState extends State<AppCrashData> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appCrashDataInitAll();
    });
  }

  Future<void> appCrashDataInitAll() async {
    appCrashDataSharedPreferences = await SharedPreferences.getInstance();
    if (!mounted) return;

    await AppCrashDataService().requestTrackingPermission();
    await AppCrashDataService().initializeOneSignal();

    appCrashDataLink =
        appCrashDataSharedPreferences.getString(appCrashDataLinkKey);
    appCrashDataWebViewType =
        appCrashDataSharedPreferences.getInt(appCrashDataWebViewTypeKey) ??
            1;

    if (appCrashDataLink != null && appCrashDataLink!.isNotEmpty) {
      appCrashDataWebViewType =
          appCrashDataDetectWebViewType(appCrashDataLink!);
      await appCrashDataSharedPreferences.setInt(
        appCrashDataWebViewTypeKey,
        appCrashDataWebViewType,
      );
    }

    if (!mounted) return;

    if (appCrashDataLink != null && appCrashDataLink!.isNotEmpty) {
      await appCrashDataSharedPreferences.setBool(
        appCrashDataWasOpenNotificationKey,
        false,
      );
      await appCrashDataSharedPreferences.setBool(
        appCrashDataSavePermissionKey,
        false,
      );
      if (!mounted) return;
      AppCrashDataService().navigateToWebView(context);
      return;
    }

    await appCrashDataInitializeMainPart();
  }

  Future<void> appCrashDataInitializeMainPart() async {
    await appCrashDataTakeParams();
  }

  int appCrashDataDetectWebViewType(String link) {
    try {
      final uri = Uri.parse(link);
      final params = uri.queryParameters;
      return int.tryParse(params['wtype'] ?? '') ?? 1;
    } catch (_) {
      return 1;
    }
  }

  Future<void> appCrashDataCreateLink() async {
    final Map<dynamic, dynamic> parameters = {};

    if (appCrashDataConversionData is Map) {
      parameters.addAll(appCrashDataConversionData as Map);
    }

    parameters.addAll({
      "tracking_status": appCrashDataTrackingPermissionStatus,
      "${appCrashDataKeyword}_id": appCrashDataAdvertisingId,
      "external_id": appCrashDataExternalId,
      "appsflyer_id": appCrashDataAppsflyerId,
    });

    final String? link =
        await AppCrashDataService().sendAppCrashDataRequest(parameters);

    appCrashDataLink = link;

    if (!mounted) return;

    if (appCrashDataLink != null && appCrashDataLink!.isNotEmpty) {
      appCrashDataWebViewType =
          appCrashDataDetectWebViewType(appCrashDataLink!);
      await appCrashDataSharedPreferences.setInt(
        appCrashDataWebViewTypeKey,
        appCrashDataWebViewType,
      );
      await appCrashDataSharedPreferences.setString(
        appCrashDataLinkKey,
        appCrashDataLink!,
      );
      await appCrashDataSharedPreferences.setBool(
        appCrashDataSuccessKey,
        true,
      );
      if (!mounted) return;
      AppCrashDataService().navigateToWebView(context);
    } else {
      await AppCrashDataService().navigateToStandardApp(
        context,
        reason:
            'appCrashDataCreateLink null or empty (backend 404/empty)',
      );
    }
  }

  Future<void> appCrashDataTakeParams() async {
    try {
      final appsFlyerOptions =
          AppCrashDataService().createAppsFlyerOptions();
      final AppsflyerSdk appsFlyerSdk = AppsflyerSdk(appsFlyerOptions);

      await appsFlyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );
      appCrashDataAppsflyerId = await appsFlyerSdk.getAppsFlyerUID();

      appsFlyerSdk.onInstallConversionData((res) async {
        if (!mounted) return;
        if (appCrashDataConversionHandled) {
          return;
        }
        appCrashDataConversionHandled = true;
        appCrashDataConversionData = res;
        await appCrashDataCreateLink();
      });

      appsFlyerSdk.startSDK(onError: (errorCode, errorMessage) {
        if (!mounted) return;
        Future.microtask(() async {
          if (!mounted) return;
          if (appCrashDataConversionHandled) return;
          appCrashDataConversionHandled = true;
          appCrashDataConversionData ??= {};
          await appCrashDataCreateLink();
        });
      });

      // Timeout fallback: if conversion data callback doesn't fire within 3 seconds,
      // proceed to create link anyway (prevents infinite loading for users in unsupported countries)
      Future.delayed(const Duration(seconds: 3), () async {
        if (!mounted) return;
        if (appCrashDataConversionHandled) return;
        appCrashDataConversionHandled = true;
        appCrashDataConversionData ??= {};
        await appCrashDataCreateLink();
      });
    } catch (_) {
      if (!mounted) return;
      if (appCrashDataConversionHandled) return;
      appCrashDataConversionHandled = true;
      appCrashDataConversionData ??= {};
      await appCrashDataCreateLink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const AppCrashDataSplash();
  }
}
