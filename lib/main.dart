import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Импортируем Hive
import 'data/models/character_model.dart'; // Для регистрации адаптера
import 'data/repositories/character_repository.dart';
import 'presentation/blocs/character_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  // Инициализация Hive
  await Hive.initFlutter();

  // Регистрация адаптеров для моделей
  Hive.registerAdapter(CharacterAdapter());

  // Открытие боксов
  await Hive.openBox<Character>('characters'); // Бокс для избранных персонажей

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
