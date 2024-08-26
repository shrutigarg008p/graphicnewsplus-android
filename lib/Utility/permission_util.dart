import 'package:permission_handler/permission_handler.dart';

/// Created by Amit Rawat on 11/19/2021.
class PermissionUtil {
  Future<void> checkPermissionStorage() async {
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
  }
}
