import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:randmapp/core/di.dart' as di;
import 'package:randmapp/data/models/character_model.dart';
import 'package:randmapp/domain/repositories/character_repository.dart';
import 'package:randmapp/presentation/blocs/character/character_bloc.dart';
import 'package:randmapp/presentation/blocs/theme/theme_bloc.dart';
import 'package:randmapp/presentation/pages/home_page.dart';
import 'package:randmapp/presentation/pages/character_detail_page.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(CharacterModelAdapter().typeId)) {
      Hive.registerAdapter(CharacterModelAdapter());
    }

    if (!Hive.isBoxOpen('characters')) {
      await Hive.openBox<CharacterModel>('characters');
    }

    di.init();
  });

  testWidgets(
    'Экран списка: Загрузка -> Список -> Переход к деталям',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeBloc()),
            BlocProvider(
              create: (_) => CharacterBloc(
                repository: di.sl<CharacterRepository>(),
              ),
            ),
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                theme: state is ThemeDark
                    ? ThemeData.dark()
                    : ThemeData.light(),
                home: const HomePage(),
              );
            },
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget,
          reason: 'Должен отображаться индикатор загрузки');

      await tester.runAsync(() async {
  await Future.delayed(const Duration(seconds: 15));
});
await tester.pump();
await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsNothing,
          reason: 'Индикатор должен исчезнуть после загрузки');
      expect(find.byType(ListTile), findsWidgets,
          reason: 'Должны отображаться карточки персонажей');
      await tester.tap(find.byType(ListTile).first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CharacterDetailPage), findsOneWidget,
          reason: 'После тапа должен открыться экран деталей');
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}