import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:randmapp/core/di.dart';
import 'package:randmapp/core/di.dart' as di;
import 'package:randmapp/domain/repositories/character_repository.dart';
import 'package:randmapp/domain/usecases/get_characters.dart';
import 'package:randmapp/domain/usecases/get_favorites.dart';
import 'data/models/character_model.dart';
import 'presentation/blocs/character/character_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(CharacterModelAdapter());

  await Hive.openBox<CharacterModel>('characters');
  di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(
            create: (context) =>
                CharacterBloc(
                  repository: sl<CharacterRepository>(),
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
      builder: (context, state) {
        return MaterialApp(
          theme: state is ThemeDark ? ThemeData.dark() : ThemeData.light(),
          home: const HomePage(),
        );
      },
    );
  }
}
