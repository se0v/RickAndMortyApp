import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:randmapp/domain/entities/character.dart';
import 'package:randmapp/presentation/blocs/character/character_bloc.dart';
import 'package:randmapp/presentation/pages/character_list_page.dart';
import 'package:randmapp/presentation/pages/character_detail_page.dart';
import 'package:randmapp/presentation/blocs/theme/theme_bloc.dart';

class MockCharacterBloc extends Mock implements CharacterBloc {}
class MockThemeBloc extends Mock implements ThemeBloc{}

void main() {
  late MockCharacterBloc mockBloc;
  late MockThemeBloc mockThemeBloc;

  setUp(() {
    mockBloc = MockCharacterBloc();
    mockThemeBloc = MockThemeBloc();
    
    when(() => mockBloc.state).thenReturn(CharacterLoading());

    when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([
      CharacterLoading(),
      CharacterLoaded(
        characters: [
          Character(id: 1, name: 'Rick Sanchez', status: 'Alive', species: 'Human', image: ''),
          Character(id: 2, name: 'Morty Smith', status: 'Alive', species: 'Human', image: ''),
        ],
        favoriteIds: {},
      ),
    ]));

    when(() => mockThemeBloc.state).thenReturn(ThemeLight()); 
    when(() => mockThemeBloc.stream).thenAnswer((_) => Stream.value(ThemeLight()));
  });

  testWidgets('Экран списка: Загрузка -> Список -> Переход к деталям', (WidgetTester tester) async {
    
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<CharacterBloc>.value(value: mockBloc),
            BlocProvider<ThemeBloc>.value(value: mockThemeBloc),
          ],
          child: const CharacterListPage(),
        ),
      ),
    );
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Rick Sanchez'), findsNothing);

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    expect(find.text('Rick Sanchez'), findsOneWidget);
    expect(find.text('Morty Smith'), findsOneWidget);

    await tester.tap(find.text('Rick Sanchez'));
    
    await tester.pumpAndSettle();
    
    expect(find.byType(CharacterDetailPage), findsOneWidget);
  });
}