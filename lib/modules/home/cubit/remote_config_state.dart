part of 'remote_config_cubit.dart';

abstract class RemoteConfigState extends Equatable {
  const RemoteConfigState();
}

class RemoteConfigInitial extends RemoteConfigState {
  final bool isUpdate;
  final String urlUpdateApp;

  RemoteConfigInitial({this.isUpdate, this.urlUpdateApp});
  @override
  List<Object> get props => [isUpdate, urlUpdateApp];
}
