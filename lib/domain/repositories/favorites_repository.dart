import '../entities/character.dart';

abstract class FavoritesRepository {
  Future<void> addFavorite(Character character);
  Future<void> removeFavorite(int characterId);
  Future<List<Character>> getFavorites();
  Future<bool> isFavorite(int characterId);
}