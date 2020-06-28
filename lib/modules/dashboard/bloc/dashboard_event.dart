part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  final propss;
  const DashboardEvent({this.propss});

  @override
  List<Object> get props => this.propss;
}

class DashboardHasStore extends DashboardEvent {}
