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

        final liked =
            _box.values.where((e) => e.isFavorite).map((e) => e.id).toList();

        for (var character in newCharacters) {
          Character newCharacter = character;
          if (liked.contains(character.id)) {
            newCharacter = character.copyWith(isFavorite: true);

            final index = newCharacters.indexOf(character);

            newCharacters.removeAt(index);
            newCharacters.insert(index, newCharacter);
          }

          if (!_box.containsKey(character.id)) {
            _box.put(character.id, newCharacter);
          }
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
      final finalEnd = end < allCharacters.length ? end : allCharacters.length;

      if (start >= allCharacters.length) {
        return [];
      }

      return allCharacters.sublist(
        start,
        finalEnd,
      );
    }
  }

  List<Character> getFavorites() {
    return _box.values.where((character) => character.isFavorite).toList();
  }

  void updateCharacter(Character character) {
    _box.put(character.id, character);
  }
}
