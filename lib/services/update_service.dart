import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import '../main.dart';
import '../widgets/app_snackbar.dart';

class UpdateService {
  static bool _hasChecked = false;

  /// Checks for an update via Google Play In-App Update API.
  /// Will silently ignore in debug/sideload builds or when not installed from Google Play.
  static Future<void> checkForUpdate() async {
    if (_hasChecked) return;
    _hasChecked = true;

    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.flexibleUpdateAllowed) {
          final result = await InAppUpdate.startFlexibleUpdate();
          if (result == AppUpdateResult.success) {
            AppSnackbar.showUpdateDownloaded(rootScaffoldMessengerKey, () {
              InAppUpdate.completeFlexibleUpdate();
            });
          }
        } else if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        }
      }
    } catch (e) {
      // Expected in debug / side-loaded builds or when Google Play Services is unavailable
      debugPrint('In-app update check info: $e');
    }
  }
}
