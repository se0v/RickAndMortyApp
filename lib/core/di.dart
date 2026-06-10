import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:randmapp/data/models/character_model.dart';
import 'package:randmapp/data/repositories/auth_repository_impl.dart';
import 'package:randmapp/data/repositories/character_repository_impl.dart';
import 'package:randmapp/data/repositories/favorites_repository_impl.dart';
import 'package:randmapp/domain/repositories/auth_repository.dart';
import 'package:randmapp/domain/repositories/character_repository.dart';
import 'package:randmapp/domain/repositories/favorites_repository.dart';

final sl = GetIt.instance;

void init() {
  // Auth Rep
  sl.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepositoryImpl(),
  );
  // Character Rep
  sl.registerLazySingleton<CharacterRepository>(() => CharacterRepositoryImpl());

  // Favorites Rep
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
    firestore: FirebaseFirestore.instance,
    hiveBox: Hive.box<CharacterModel>('characters'),
    getUserId: () => sl<AuthRepository>().currentUser?.uid, 
  ),
  );
  }