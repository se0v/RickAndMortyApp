import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randmapp/data/models/character_model.dart';
import 'package:randmapp/data/repositories/character_repository.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;
  List<Character> _characters = [];
  int _currentPage = 1;

  CharacterBloc({required this.repository}) : super(CharacterInitial()) {
    on<FetchCharacters>((event, emit) async {
      try {
        if (_currentPage == 1) {
          emit(CharacterLoading());
        }

        final newCharacters =
            await repository.fetchCharacters(page: event.page);
        _characters.addAll(newCharacters);

        emit(CharacterLoaded(
          characters: _characters,
          currentPage: _currentPage,
        ));
      } catch (e) {
        emit(CharacterError(e.toString()));
      }
    });

    on<ToggleFavorite>((event, emit) async {
      final updatedCharacter = event.character.copyWith(
        isFavorite: !event.character.isFavorite,
      );

      _characters = _characters.map((character) {
        if (character.id == updatedCharacter.id) {
          return updatedCharacter;
        }
        return character;
      }).toList();

      emit(CharacterUpdated());
      emit(CharacterLoaded(
        characters: _characters,
        currentPage: _currentPage,
      ));
    });
  }

  void loadNextPage() {
    _currentPage++;
    add(FetchCharacters(page: _currentPage));
  }
}
