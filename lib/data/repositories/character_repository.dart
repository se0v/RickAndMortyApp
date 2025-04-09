import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/character_model.dart';

class CharacterRepository {
  final String baseUrl = 'https://rickandmortyapi.com/api/character';
  final Box<Character> _box = Hive.box<Character>('characters');

  Future<List<Character>> fetchCharacters({required int page}) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  List<Character> getFavorites() {
    return _box.values.where((character) => character.isFavorite).toList();
  }

  void toggleFavorite(Character character) {
    character.isFavorite = !character.isFavorite;
    _box.put(character.id, character);
  }
}
