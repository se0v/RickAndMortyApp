class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    this.isFavorite = false,
  });
}