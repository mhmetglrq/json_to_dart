import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_to_dart/injection_container.dart';

import 'features/jsonToDart/presentation/bloc/dashboard_bloc.dart';
import 'my_app.dart';

void main() async {
  await initializeDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<DashboardBloc>(
        create: (context) => sl<DashboardBloc>(),
      )
    ],
    child: const MyApp(),
  ));
}
