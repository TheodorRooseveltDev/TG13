import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:big_boss_fishing/app/routes.dart';

import 'app_crash_data.dart';
import 'app_crash_data_parameters.dart';
import 'app_crash_data_web_view.dart';
import 'app_crash_data_web_view_two.dart';

class AppCrashDataService {
  void navigateToWebView(BuildContext context) {
    final bool useCustomTab =
        appCrashDataWebViewType == 2 && appCrashDataLink != null;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            useCustomTab
                ? AppCrashDataWebViewTwo(link: appCrashDataLink!)
                : const AppCrashDataWebViewWidget(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> initializeOneSignal() async {
    if (!Platform.isIOS) return;
    try {
      // Set debug level first
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      
      // Disable location sharing
      OneSignal.Location.setShared(false);

      // Disable consent requirement - this ensures OneSignal can register for push
      OneSignal.consentRequired(false);
      OneSignal.consentGiven(true);

      // Initialize OneSignal with app ID
      OneSignal.initialize(appCrashDataOneSignalAppId);

      // Generate external ID early
      appCrashDataExternalId = const Uuid().v1();

      // Add push subscription observer BEFORE requesting permission
      // This ensures we catch the token when APNS delegate fires
      OneSignal.User.pushSubscription.addObserver((state) {
        final token = state.current.token;
        final id = state.current.id;
        debugPrint('OneSignal: Push subscription changed - token: $token, id: $id');
        if (token != null && token.isNotEmpty) {
          // Token received - APNS delegate fired successfully
          debugPrint('OneSignal: APNS token received successfully');
        }
      });

      // Add notification permission observer
      OneSignal.Notifications.addPermissionObserver((permission) {
        debugPrint('OneSignal: Permission changed to: $permission');
      });

      // Add click listener for notifications
      OneSignal.Notifications.addClickListener((event) {
        debugPrint('OneSignal: Notification clicked');
      });

      // Add foreground will display handler - important for iOS
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        debugPrint('OneSignal: Notification will display in foreground');
        // Display the notification
        event.notification.display();
      });

      // Small delay to ensure SDK is fully initialized before requesting permission
      await Future.delayed(const Duration(milliseconds: 300));

      // Request permission - this triggers APNS registration
      final permissionGranted = await OneSignal.Notifications.requestPermission(true);
      debugPrint('OneSignal: Permission granted: $permissionGranted');

      // Wait a bit for APNS registration to complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Login after permission is granted to associate the user
      if (appCrashDataExternalId != null) {
        OneSignal.login(appCrashDataExternalId!);
        debugPrint('OneSignal: Logged in with external ID: $appCrashDataExternalId');
      }
    } catch (e) {
      debugPrint('OneSignal initialization error: $e');
    }
  }

  Future<void> requestPermissionOneSignal() async {
    if (!Platform.isIOS) return;
    try {
      final current =
          await OneSignal.Notifications.permissionNative(); // system-level
      if (current == OSNotificationPermission.authorized ||
          current == OSNotificationPermission.provisional ||
          current == OSNotificationPermission.ephemeral) {
        return;
      }

      await OneSignal.Notifications.requestPermission(true);
      appCrashDataExternalId ??= const Uuid().v1();
      OneSignal.login(appCrashDataExternalId!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  void notifyOneSignalAccepted() {
    if (!Platform.isIOS) return;
    try {
      appCrashDataExternalId ??= const Uuid().v1();
      OneSignal.login(appCrashDataExternalId!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  void sendRequestToBackend() {
    if (!Platform.isIOS) return;
    try {
      appCrashDataExternalId ??= const Uuid().v1();
      OneSignal.login(appCrashDataExternalId!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  Future<void> navigateToStandardApp(
    BuildContext context, {
    String reason = '',
  }) async {
    String? initialLocation;
    try {
      // Prefer the latest persisted value; fall back to the in-memory instance.
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboardingPersisted =
          prefs.getBool('has_seen_onboarding') ?? false;
      final hasSeenOnboardingCached = appCrashDataSharedPreferences
              .getBool('has_seen_onboarding') ??
          false;
      final onboardingAlreadyShown =
          appCrashDataSharedPreferences.getBool(
                appCrashDataOnboardingShownKey,
              ) ??
              false;
      final hasSeenOnboarding =
          hasSeenOnboardingPersisted ||
              hasSeenOnboardingCached ||
              onboardingAlreadyShown;

      initialLocation =
          hasSeenOnboarding ? AppRoutes.home : AppRoutes.onboarding;

      if (!hasSeenOnboarding) {
        await appCrashDataSharedPreferences.setBool(
          appCrashDataOnboardingShownKey,
          true,
        );
      }
    } catch (_) {}
    appCrashDataOpenStandardAppLogic(
      context,
      initialLocation: initialLocation,
    );
  }

  Future<bool> isSystemPermissionGranted() async {
    if (!Platform.isIOS) return false;
    try {
      final status = await OneSignal.Notifications.permissionNative();
      return status == OSNotificationPermission.authorized ||
          status == OSNotificationPermission.provisional ||
          status == OSNotificationPermission.ephemeral;
    } catch (_) {
      return false;
    }
  }

  AppsFlyerOptions createAppsFlyerOptions() {
    return AppsFlyerOptions(
      afDevKey: (appCrashDataAfDevKeyPart1 + appCrashDataAfDevKeyPart2),
      appId: appCrashDataAppsFlyerAppId,
      timeToWaitForATTUserAuthorization: 5,
      showDebug: true,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    );
  }

  Future<void> requestTrackingPermission() async {
    if (Platform.isIOS) {
      try {
        TrackingStatus status =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        appCrashDataTrackingPermissionStatus = status.toString();
        if (status == TrackingStatus.notDetermined) {
          await Future.delayed(const Duration(milliseconds: 200));
          status = await AppTrackingTransparency.requestTrackingAuthorization();
          appCrashDataTrackingPermissionStatus = status.toString();
        }
        if (status == TrackingStatus.authorized) {
          await _getAdvertisingId();
        }
      } catch (_) {}
    }
  }

  Future<void> _getAdvertisingId() async {
    try {
      appCrashDataAdvertisingId = await AdvertisingId.id(true);
    } catch (_) {}
  }

  Future<String?> sendAppCrashDataRequest(
      Map<dynamic, dynamic> parameters) async {
    try {
      final jsonString = json.encode(parameters);
      final base64Parameters = base64.encode(utf8.encode(jsonString));

      final requestBody = {appCrashDataKeyword: base64Parameters};

      final response = await http.post(
        Uri.parse(appCrashDataBackendUrl),
        body: requestBody,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
