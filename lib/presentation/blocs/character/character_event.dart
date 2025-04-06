part of 'character_bloc.dart';

abstract class CharacterEvent {}

class FetchCharacters extends CharacterEvent {
  final int page;

  FetchCharacters({required this.page});
}

class ToggleFavorite extends CharacterEvent {
  final Character character;

  ToggleFavorite({required this.character});
}
