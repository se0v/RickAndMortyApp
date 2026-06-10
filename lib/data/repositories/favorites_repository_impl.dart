import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../models/character_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FirebaseFirestore _firestore;
  final Box<CharacterModel> _hiveBox;
  final String? Function() _getUserId;

  FavoritesRepositoryImpl({
    required FirebaseFirestore firestore,
    required Box<CharacterModel> hiveBox,
    required String? Function() getUserId,
      })  : _firestore = firestore,
        _hiveBox = hiveBox,
        _getUserId = getUserId;

  @override
  Future<void> addFavorite(Character character) async {
    final userId = _getUserId();
    if (userId == null) return;

    await _hiveBox.put(
      character.id, 
      CharacterModel(
        id: character.id,
        name: character.name,
        status: character.status,
        species: character.species,
        image: character.image,
        isFavorite: true,
      ),
    );

    // sync withFirestore
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(character.id.toString())
        .set(character.toMap());
  }

  @override
  Future<void> removeFavorite(int characterId) async {
    final userId = _getUserId();
    if (userId == null) return;

    await _hiveBox.delete(characterId);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(characterId.toString())
        .delete();
  }

  @override
Future<List<Character>> getFavorites() async {
  final userId = _getUserId();
  if (userId == null) return [];

  try {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    final cloudFavs = snapshot.docs
        .map((doc) => Character.fromMap(doc.data()))
        .toList();

    // upd local cache 
    await _hiveBox.clear();
    for (final char in cloudFavs) {
      await _hiveBox.put(
  char.id, 
  CharacterModel(
    id: char.id,
    name: char.name,
    status: char.status,
    species: char.species,
    image: char.image,
    isFavorite: true,
  ),
);
    }

    return cloudFavs;
  } catch (e) {
    // to offline mode
    return _hiveBox.values.map((m) => m.toEntity()).toList();
  }
}

  @override
Future<bool> isFavorite(int characterId) async {
  final userId = _getUserId();
  if (userId == null) return false;
  
  final doc = await _firestore
      .collection('users')
      .doc(userId)
      .collection('favorites')
      .doc(characterId.toString())
      .get();
  
  return doc.exists;
}
}