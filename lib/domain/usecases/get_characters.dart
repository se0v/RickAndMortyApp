import 'package:randmapp/domain/repositories/character_repository.dart';
import 'package:randmapp/domain/entities/character.dart';

class GetCharacters {
  final CharacterRepository repository;
  GetCharacters(this.repository);

  Future<List<Character>> call(int page) async {
    return await repository.getCharacters(page);
  }
}