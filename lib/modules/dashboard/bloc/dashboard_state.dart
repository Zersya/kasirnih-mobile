part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  final propss;
  const DashboardState({this.propss});

  @override
  List<Object> get props => propss;
}

class DashboardInitial extends DashboardState {
  final bool isHasStore;
  DashboardInitial({this.isHasStore = false}) : super(propss: [isHasStore]);
}

class DashboardLoading extends DashboardState {
  final bool isHasStore;
  DashboardLoading(this.isHasStore) : super(propss: [isHasStore]);
}
