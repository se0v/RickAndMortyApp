


import 'package:randmapp/data/models/character_model.dart';
import 'package:randmapp/domain/entities/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getCharacters(int page);
  //List<Character> getFavorites();
  //void updateFavoriteStatus(int characterId, bool isFavorite);
}