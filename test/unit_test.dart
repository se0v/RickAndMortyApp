import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:randmapp/domain/entities/character.dart';
import 'package:randmapp/domain/repositories/character_repository.dart';
import 'package:randmapp/presentation/blocs/character/character_bloc.dart';

class MockCharactersRepository extends Mock implements CharacterRepository {}

void main() {
  late MockCharactersRepository mockRepository;
  late CharacterBloc bloc;

  setUp(() {
    mockRepository = MockCharactersRepository();
    
    bloc = CharacterBloc(repository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('CharactersBloc Tests', () {
    
    test('При успешном вызове getCharacters, состояние меняется на Loaded с непустым списком', () async {
      final tCharacters = [
        Character(id: 1, name: 'Rick Sanchez', status: '', species: '', image: ''),
        Character(id: 2, name: 'Morty Smith', status: '', species: '', image: ''),
      ];

      when(() => mockRepository.getCharacters(0)).thenAnswer((_) async => tCharacters);
      bloc.add(FetchCharacters(page: 0));
      await Future.delayed(const Duration(milliseconds: 3000));
      expect(bloc.state, isA<CharacterLoaded>());
      final loadedState = bloc.state as CharacterLoaded;
      expect(loadedState.characters.isNotEmpty, true);
      expect(loadedState.characters.length, 2);
      expect(loadedState.characters.first.name, 'Rick Sanchez');
      
      verify(() => mockRepository.getCharacters(0)).called(1);
    });

    test('При ошибке в репозитории, состояние меняется на Error', () async {
      when(() => mockRepository.getCharacters(0)).thenThrow(Exception('Network Error'));

      bloc.add(FetchCharacters(page: 0));
      await Future.delayed(const Duration(milliseconds: 3000));

      expect(bloc.state, isA<CharacterError>());
      
      final errorState = bloc.state as CharacterError;
      expect(errorState.message.contains('Network Error'), true);
    });
  });
}

// BLOC_TEST
// class MockCharactersRepository extends Mock implements CharacterRepository {}

// void main() {
//   late MockCharactersRepository mockRepository;

//   setUp(() {
//     mockRepository = MockCharactersRepository();
//   });

//   group('CharacterBloc Tests', () {
    
//     blocTest<CharacterBloc, CharacterState>(
//       'emits [CharacterLoading, CharacterLoaded] when FetchCharacters is added',
      
//       build: () {
//         when(() => mockRepository.getCharacters(0)).thenAnswer((_) async => [
//           Character(id: 1, name: 'Rick Sanchez', status: '', species: '', image: ''),
//           Character(id: 2, name: 'Morty Smith', status: '', species: '', image: ''),
//         ]);
//         return CharacterBloc(repository: mockRepository);
//       },
      
//       act: (bloc) => bloc.add(FetchCharacters(page: 0)),
      
//       expect: () => [
//         isA<CharacterLoading>(),
//         isA<CharacterLoaded>().having(
//           (state) => state.characters, 
//           'characters list', 
//           isNotEmpty,
//         ),
//       ],
      
//       verify: (_) {
//         verify(() => mockRepository.getCharacters(0)).called(1);
//       },
//     );

//     blocTest<CharacterBloc, CharacterState>(
//       'emits [CharacterLoading, CharacterError] when FetchCharacters fails',
//       build: () {
//         when(() => mockRepository.getCharacters(0)).thenThrow(Exception('Network Error'));
//         return CharacterBloc(repository: mockRepository);
//       },
//       act: (bloc) => bloc.add(FetchCharacters(page: 0)),
//       expect: () => [
//         isA<CharacterLoading>(),
//         isA<CharacterError>(),
//       ],
//     );
//   });
// }