import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  final PackageInfo packageInfo;

  AppInfo._(this.packageInfo);

  static Future<AppInfo> create() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return AppInfo._(packageInfo);
  }

  String get version {
    if (packageInfo.buildNumber.isNotEmpty) {
      return '${packageInfo.version}+${packageInfo.buildNumber}';
    }
    return packageInfo.version;
  }
}
