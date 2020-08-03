import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:package_info/package_info.dart';

part 'remote_config_state.dart';

class RemoteConfigCubit extends Cubit<RemoteConfigState> {
  RemoteConfigCubit() : super(RemoteConfigInitial());
  final _storage = FlutterSecureStorage();

  void versionCheck(bool debugMode) async {
    try {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      await remoteConfig
          .setConfigSettings(RemoteConfigSettings(debugMode: debugMode));
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.setDefaults(<String, dynamic>{
        'limit_app_list': 100,
        'android_app_version': 0,
      });
      await remoteConfig.activateFetched();

      final limitListValue = remoteConfig.getInt('limit_app_list');
      final versionCodeValue = remoteConfig.getInt('android_app_version');

      await _storage.write(key: kLimitData, value: '$limitListValue');

      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final int localBuildNumber = int.parse(packageInfo.buildNumber);

      emit(RemoteConfigInitial(isUpdate: localBuildNumber < versionCodeValue));
    } catch (e) {
      toastError(e.message);
    }
  }
}
