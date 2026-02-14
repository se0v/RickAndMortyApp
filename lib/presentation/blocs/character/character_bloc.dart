import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randmapp/domain/entities/character.dart';
import 'package:randmapp/domain/repositories/character_repository.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;
  List<Character> _characters = [];
  Set<int> _favoriteIds = {};
  int _currentPage = 1;

  CharacterBloc({
    required this.repository}) : super(CharacterLoading()) {
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

      await Future.delayed(const Duration(seconds: 2));

      final newCharacters = await repository.getCharacters(event.page);
      _characters.addAll(newCharacters);
      if (_favoriteIds.isEmpty) {
      final favorites = await repository.getFavorites();
      _favoriteIds = favorites.map((c) => c.id).toSet();
    }
    emit(CharacterLoaded(
      characters: _characters,
      favoriteIds: _favoriteIds,
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
    //repository.updateCharacter(updatedCharacter);

    // emit(CharacterLoaded(
    //   characters: _characters,
    // ));
  }

  void loadNextPage() {
    _currentPage++;
    add(FetchCharacters(page: _currentPage));
  }
}
