part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  final String currentRoute;
  final String? message;
  final String dartClass;
  

  const DashboardState({
    this.currentRoute = '/',
    this.message,
    this.dartClass = '',
  });

  @override
  List<Object?> get props => [
        currentRoute,
        message,
      ];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial({
    super.currentRoute,
    super.message,
  });
}

class DashboardLoading extends DashboardState {
  const DashboardLoading({
    super.currentRoute,
    super.message,
  });
}

class DashboardLoaded extends DashboardState {
  @override
  final String dartClass;

  const DashboardLoaded({
    required this.dartClass,
    super.currentRoute,
    super.message,
  });

  @override
  List<Object?> get props => [
        dartClass,
        currentRoute,
        message,
      ];
}
