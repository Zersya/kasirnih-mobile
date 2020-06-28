part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  final propss;
  const DashboardState({this.propss});

  @override
  List<Object> get props => propss;
}

class DashboardInitial extends DashboardState {
  final int version;
  final bool isHasStore;
  

  DashboardInitial({this.version = 0, this.isHasStore = false})
      : super(propss: [version, isHasStore]);
}

class DashboardLoading extends DashboardState {
  final int version;
  final bool isHasStore;
  

  DashboardLoading(this.version, this.isHasStore)
      : super(propss: [version, isHasStore]);
}
