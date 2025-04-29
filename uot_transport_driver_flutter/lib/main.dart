import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport_driver_flutter/auth_feature/model/repository/driver_auth_repository.dart';
import 'package:uot_transport_driver_flutter/home_feature/model/repository/active_trips_repository.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/screens/splash_screen.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view_model/cubit/driver_auth_cubit.dart';
import 'package:uot_transport_driver_flutter/home_feature/view_model/cubit/active_trips_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DriverAuthRepository>(
          create: (context) => DriverAuthRepository(),
        ),
        RepositoryProvider<ActiveTripsRepository>(
          create: (context) => ActiveTripsRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DriverAuthCubit>(
            create: (context) => DriverAuthCubit(
              authRepository: context.read<DriverAuthRepository>(),
            ),
          ),
          BlocProvider<ActiveTripsCubit>(
            create: (context) => ActiveTripsCubit(
              repository: context.read<ActiveTripsRepository>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Almarai',
      ),
      home: const SplashScreen(),
    );
  }
}