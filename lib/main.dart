import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/character_model.dart';
import 'data/repositories/character_repository.dart';
import 'presentation/blocs/character/character_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(CharacterAdapter());

  await Hive.openBox<Character>('characters');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CharacterBloc(repository: CharacterRepository()),
        child: const HomePage(),
      ),
    );
  }
}
