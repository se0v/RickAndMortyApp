import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigRepository {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await _remoteConfig.fetchAndActivate();
  }

  bool get isDarkMode => _remoteConfig.getBool('dark_mode');
}