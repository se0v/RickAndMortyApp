import 'package:hive_flutter/hive_flutter.dart';
import 'package:randmapp/domain/entities/character.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
class CharacterModel {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4) final String? image;

  @HiveField(5)
  final bool isFavorite;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    this.image,
    this.isFavorite = false,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      image: null,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Character toEntity() => Character(
    id: id, 
    name: name, 
    status: status, 
    species: species, 
    
  );
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'isFavorite': isFavorite,
    };
  }

  CharacterModel copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    bool? isFavorite,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
