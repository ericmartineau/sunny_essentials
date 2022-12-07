import 'package:flutter/widgets.dart';
import 'package:info_x/sunny_get.dart';
import 'package:pub_semver/pub_semver.dart' as semver;
import 'package:pub_semver/pub_semver.dart';

/// Contains fallback app info, in case we can't look up app info from apple's servers
class FallbackAppInfo extends AppInfo {
  final String appleAppID;
  final String appleAppName;

  FallbackAppInfo(
      {String? appStoreUrl,
      String? appBaseUrl,
      required String packageName,
      Version? appVersion,
      required String appName,
      String? buildNumber,
      required this.appleAppID,
      String? appleAppName})
      : appleAppName = appleAppName ?? appName,
        super(
            appBaseUrl: appBaseUrl,
            appStoreUrl: appStoreUrl,
            packageName: packageName,
            appVersion: appVersion ?? Version.parse("0.0.1"),
            appName: (appleAppName ?? appName),
            buildNumber: buildNumber);
}

class AppInfo {
  final String? appBaseUrl;
  final String packageName;
  final semver.Version appVersion;
  final String appName;
  final String? buildNumber;
  final String? appStoreUrl;

  const AppInfo(
      {this.appStoreUrl,
      this.appBaseUrl,
      required this.packageName,
      required this.appVersion,
      required this.appName,
      this.buildNumber});

  AppInfo.unknown()
      : this(
          packageName: 'unknown',
          appName: 'app',
          appVersion: Version.none,
        );

  String get appID {
    return packageName;
  }

  Map<String, dynamic> toMap() {
    return {
      'appBaseUrl': this.appBaseUrl,
      'packageName': this.packageName,
      'appVersion': this.appVersion,
      'appName': this.appName,
      'buildNumber': this.buildNumber,
      'appStoreUrl': this.appStoreUrl,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  static AppInfo of(BuildContext context) {
    return sunny.find<AppInfo>(context: context) ?? AppInfo.unknown();
  }
}
