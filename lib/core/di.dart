import 'package:get_it/get_it.dart';
import 'package:randmapp/data/repositories/character_repository_impl.dart';
import 'package:randmapp/domain/repositories/character_repository.dart';
import 'package:randmapp/domain/usecases/get_characters.dart';
import 'package:randmapp/domain/usecases/get_favorites.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<CharacterRepository>(() => CharacterRepositoryImpl());
}

// class ApiService {
//   ApiService._internal();
//   static final ApiService _instance = ApiService._internal();
//   factory ApiService() => _instance;
// }

// final api1 = ApiService();
// final api2 = ApiService();
