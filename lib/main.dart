import 'package:examen/injection.dart';
import 'package:examen/src/presentation/pages/listRoom/ReservationListPage.dart';
import 'package:examen/src/presentation/pages/registerRoom/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:examen/injection.dart'; // Inyección de dependencias
import 'package:examen/src/presentation/pages/blocProviders.dart'; // BlocProviders

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencias(); // Configurar dependencias
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders, // Proveer los BLoCs
      child: MaterialApp(
        builder: FToastBuilder(), // Para mostrar toasts si es necesario
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        initialRoute: 'listPage', // Ruta inicial
        routes: {
          'listPage': (BuildContext context) => ReservationListPage(),
          'registerPage': (BuildContext context) => RegisterRoomPage(),
        },
      ),
    );
  }
}





