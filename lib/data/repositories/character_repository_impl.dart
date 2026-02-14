import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:randmapp/domain/repositories/character_repository.dart';
import 'package:randmapp/domain/entities/character.dart';
import '../models/character_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final String baseUrl = 'https://rickandmortyapi.com/api/character';
  final Box<CharacterModel> _box = Hive.box<CharacterModel>('characters');

  // Future<bool> _hasInternet() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  //   } on SocketException catch (_) {
  //     return false;
  //   }
  // }

  Future<List<CharacterModel>> fetchCharacters({required int page}) async {
    //bool hasInternet = await _hasInternet();
      try{
      final response = await http.get(Uri.parse('$baseUrl?page=$page'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        final newCharacters =
            results.map((json) => CharacterModel.fromJson(json)).toList();

        final liked =
            _box.values.where((e) => e.isFavorite).map((e) => e.id).toList();

        for (var character in newCharacters) {
          CharacterModel newCharacter = character;
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
      }
     catch (e) {
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

  @override
  Future<List<Character>> getCharacters(int page) async {
    final models = await fetchCharacters(page: page);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  List<Character> getFavorites() {
    final models = _box.values.where((c) => c.isFavorite).toList();
    return models.map((m) => m.toEntity()).toList();
    //return _box.values.where((character) => character.isFavorite).toList();
  }

  @override
  void updateFavoriteStatus(int characterId, bool isFavorite) {
    final existing = _box.get(characterId);
    if (existing != null) {
      final updated = existing.copyWith(isFavorite: isFavorite);
      _box.put(characterId, updated);
    }
  }

  void updateCharacter(CharacterModel character) {
    _box.put(character.id, character);
  }
}
