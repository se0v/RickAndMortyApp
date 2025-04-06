import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/character_model.dart';
import '../../../data/repositories/character_repository.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;

  CharacterBloc({required this.repository}) : super(CharacterInitial()) {
    on<FetchCharacters>(_onFetchCharacters);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onFetchCharacters(
      FetchCharacters event, Emitter<CharacterState> emit) async {
    emit(CharacterLoading());
    try {
      final characters = await repository.fetchCharacters(event.page);
      emit(CharacterLoaded(characters: characters));
    } catch (e) {
      emit(CharacterError(message: e.toString()));
    }
  }

  void _onToggleFavorite(
      ToggleFavorite event, Emitter<CharacterState> emit) async {
    final updatedCharacters =
        List<Character>.from((state as CharacterLoaded).characters);
    final characterIndex =
        updatedCharacters.indexWhere((c) => c.id == event.character.id);
    if (characterIndex != -1) {
      updatedCharacters[characterIndex] =
          updatedCharacters[characterIndex].copyWith(
        isFavorite: !updatedCharacters[characterIndex].isFavorite,
      );
      emit(CharacterLoaded(characters: updatedCharacters));
    }
  }
}
