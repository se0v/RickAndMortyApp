import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/character_model.dart';
import 'dart:io';

class CharacterRepository {
  final String baseUrl = 'https://rickandmortyapi.com/api/character';
  final Box<Character> _box = Hive.box<Character>('characters');

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<List<Character>> fetchCharacters({required int page}) async {
    bool hasInternet = await _hasInternet();

    if (hasInternet) {
      final response = await http.get(Uri.parse('$baseUrl?page=$page'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        final newCharacters =
            results.map((json) => Character.fromJson(json)).toList();

        for (var character in newCharacters) {
          _box.put(character.id, character);
        }

        return newCharacters;
      } else {
        throw Exception('Failed to load characters');
      }
    } else {
      final allCharacters = _box.values.toList();
      const pageSize = 20;
      final start = (page - 1) * pageSize;
      final end = start + pageSize;

      return allCharacters.sublist(
        start,
        end < allCharacters.length ? end : allCharacters.length,
      );
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
