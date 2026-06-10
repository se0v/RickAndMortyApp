import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:randmapp/core/di.dart';
import 'package:randmapp/core/di.dart' as di;
import 'package:randmapp/data/repositories/remote_config_repository.dart';
import 'package:randmapp/domain/repositories/auth_repository.dart';
import 'package:randmapp/domain/repositories/character_repository.dart';
import 'package:randmapp/domain/repositories/favorites_repository.dart';
import 'package:randmapp/presentation/blocs/auth/auth_bloc.dart';
import 'package:randmapp/presentation/pages/login_page.dart';
import 'data/models/character_model.dart';
import 'presentation/blocs/character/character_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;


  final remoteConfig = RemoteConfigRepository();
  await remoteConfig.init();
  final isDarkMode = remoteConfig.isDarkMode;

  await Hive.initFlutter();

  Hive.registerAdapter(CharacterModelAdapter());

  await Hive.openBox<CharacterModel>('characters');
  di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()..add(SetTheme(isDark: isDarkMode))),
        BlocProvider(create: (_) => AuthBloc(authRepository: sl<AuthRepository>())),
        BlocProvider(
            create: (context) =>
                CharacterBloc(
                  repository: sl<CharacterRepository>(), 
                  favoritesRepository: sl<FavoritesRepository>(),
                  )),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          theme: themeState is ThemeDark ? ThemeData.dark() : ThemeData.light(),
          home: BlocBuilder<AuthBloc, AuthState>(
  builder: (context, authState) {
    if (authState is AuthAuthenticated) {
      return BlocProvider(
        key: ValueKey(authState.user.uid),
        create: (context) => CharacterBloc(
          repository: sl<CharacterRepository>(),
          favoritesRepository: sl<FavoritesRepository>(),
        ),
        child: const HomePage(),
      );
    }
    return const LoginPage();
  },
),
        );
      },
    );
  }
}
