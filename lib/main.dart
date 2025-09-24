import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sombola/services/disease_provider.dart';
import 'package:sombola/src/home_page/home.dart';
import 'package:sombola/src/home_page/models/disease_model.dart';
import 'package:sombola/src/suggestions_page/suggestions.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DiseaseAdapter());

  await Hive.openBox<Disease>('plant_diseases');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DiseaseService>(
      create: (context) => DiseaseService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Detect diseases',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff00ad59)),
          fontFamily: 'SFRegular',
          textTheme: const TextTheme(
            headlineLarge: TextStyle(fontFamily: 'SFBold'),
            headlineMedium: TextStyle(fontFamily: 'SFBold'),
            headlineSmall: TextStyle(fontFamily: 'SFBold'),
            titleLarge: TextStyle(fontFamily: 'SFBold'),
            titleMedium: TextStyle(fontFamily: 'SFBold'),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F9F7),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 4,
            shape: StadiumBorder(),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case Suggestions.routeName:
                    return const Suggestions();
                  case Home.routeName:
                  default:
                    return const Home();
                }
              });
        },
      ),
    );
  }
}
