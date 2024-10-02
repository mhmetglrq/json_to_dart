import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardInitial());

  void onChangeCurrentRoute(
      ChangeCurrentRouteEvent event, Emitter<DashboardState> emit) {
    emit(DashboardLoaded(
      currentRoute: event.route,
      dartClass: state.dartClass,
    ));
  }

  void onGenerateDartClass(
      DashboardGenerateDartClass event, Emitter<DashboardState> emit) {
    emit(DashboardLoaded(
      currentRoute: state.currentRoute,
      dartClass: event.json,
    ));
  }
}
