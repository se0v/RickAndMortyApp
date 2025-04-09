part of 'character_bloc.dart';

abstract class CharacterState {}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<Character> characters;
  final int currentPage;

  CharacterLoaded({required this.characters, required this.currentPage});
}

class CharacterError extends CharacterState {
  final String message;

  CharacterError(this.message);
}

class CharacterUpdated extends CharacterState {}
