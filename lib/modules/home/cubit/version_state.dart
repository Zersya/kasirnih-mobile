part of 'version_cubit.dart';

abstract class VersionState extends Equatable {
  const VersionState();
}

class VersionInitial extends VersionState {
  final Stream streamVersion;

  VersionInitial({this.streamVersion});
  @override
  List<Object> get props => [streamVersion];
}
