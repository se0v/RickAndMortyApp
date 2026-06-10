import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randmapp/domain/entities/character.dart';
import 'package:randmapp/domain/repositories/character_repository.dart';
import 'package:randmapp/domain/repositories/favorites_repository.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;
  final FavoritesRepository favoritesRepository;
  final List<Character> _characters = [];
  Set<int> _favoriteIds = {};
  int _currentPage = 1;

  CharacterBloc({
    required this.repository,
    required this.favoritesRepository,
    }) : super(CharacterLoading()) {
    on<FetchCharacters>(_onFetchCharacters);
    on<ToggleFavorite>(_onToggleFavorite);

    add(FetchCharacters(page: 1));
  }

  Future<void> _onFetchCharacters(FetchCharacters event, Emitter<CharacterState> emit) async {
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
      
      if (event.page == 1) {
        final favs = await favoritesRepository.getFavorites();
        _favoriteIds = favs.map((c) => c.id).toSet();
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

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<CharacterState> emit) async {
    final isFav = await favoritesRepository.isFavorite(event.character.id);

    if (isFav) {
      await favoritesRepository.removeFavorite(event.character.id);
      _favoriteIds.remove(event.character.id);
    } else {
      await favoritesRepository.addFavorite(event.character);
      _favoriteIds.add(event.character.id);
    }

    emit(state is CharacterLoaded
        ? (state as CharacterLoaded).copyWith(favoriteIds: _favoriteIds)
        : state);
  }

  void loadNextPage() {
    _currentPage++;
    add(FetchCharacters(page: _currentPage));
  }
}
