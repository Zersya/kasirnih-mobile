part of 'remote_config_cubit.dart';

abstract class RemoteConfigState extends Equatable {
  const RemoteConfigState();
}

class RemoteConfigInitial extends RemoteConfigState {
  final bool isUpdate;

  RemoteConfigInitial({this.isUpdate});
  @override
  List<Object> get props => [isUpdate];
}
