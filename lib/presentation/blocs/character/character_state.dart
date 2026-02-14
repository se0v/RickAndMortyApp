
part of 'character_bloc.dart';

abstract class CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<Character> characters;
  final Set<int> favoriteIds;
  final bool isLoading;
  final bool isLastPage;

  CharacterLoaded({
    required this.characters,
    required this.favoriteIds,
    this.isLoading = false,
    this.isLastPage = false,
  });

  CharacterLoaded copyWith({
    List<Character>? characters,
    bool? isLoading,
    bool? isLastPage,
  }) {
    return CharacterLoaded(
      characters: characters ?? this.characters,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

class CharacterError extends CharacterState {
  final String message;

  CharacterError(this.message);
}
