import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randmapp/data/models/character_model.dart';
import 'package:randmapp/data/repositories/character_repository.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;
  List<Character> _characters = [];
  int _currentPage = 1;

  CharacterBloc({required this.repository}) : super(CharacterLoading()) {
    on<FetchCharacters>(_onFetchCharacters);
    on<ToggleFavorite>(_onToggleFavorite);

    add(FetchCharacters(page: 1));
  }

  Future<void> _onFetchCharacters(event, emit) async {
    final currentState = state;
    try {
      if (currentState is CharacterLoaded) {
        emit(
          currentState.copyWith(isLoading: true),
        );
      } else {
        emit(CharacterLoading());
      }

      await Future.delayed(Duration(seconds: 2));

      final newCharacters = await repository.fetchCharacters(page: event.page);
      _characters.addAll(newCharacters);

      emit(CharacterLoaded(
        characters: _characters,
        isLastPage: newCharacters.isEmpty,
      ));
    } catch (e, st) {
      emit(CharacterError(e.toString()));
      print(st);
    }
  }

  Future<void> _onToggleFavorite(event, emit) async {
    final updatedCharacter = event.character.copyWith(
      isFavorite: !event.character.isFavorite,
    );

    _characters = _characters.map<Character>((character) {
      if (character.id == updatedCharacter.id) {
        return updatedCharacter;
      }
      return character;
    }).toList();

    //TODO:
    repository.updateCharacter(updatedCharacter);

    emit(CharacterLoaded(
      characters: _characters,
    ));
  }

  void loadNextPage() {
    _currentPage++;
    add(FetchCharacters(page: _currentPage));
  }
}
