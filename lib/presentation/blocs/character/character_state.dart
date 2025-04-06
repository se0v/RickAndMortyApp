part of 'character_bloc.dart';

abstract class CharacterState {}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<Character> characters;

  CharacterLoaded({required this.characters});
}

class CharacterError extends CharacterState {
  final String message;

  CharacterError({required this.message});
}

class CharacterUpdated extends CharacterState {}
