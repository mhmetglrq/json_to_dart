part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardGenerateDartClass extends DashboardEvent {
  final String json;

  const DashboardGenerateDartClass({
    required this.json,
  });

  @override
  List<Object> get props => [json];
}

class ChangeCurrentRouteEvent extends DashboardEvent {
  final String route;

  const ChangeCurrentRouteEvent({
    required this.route,
  });

  @override
  List<Object> get props => [route];
}
