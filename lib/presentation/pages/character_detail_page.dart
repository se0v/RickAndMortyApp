import 'package:flutter/material.dart';
import 'package:randmapp/domain/entities/character.dart';

class CharacterDetailPage extends StatelessWidget {
  final Character character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
  radius: 60,
  backgroundImage: character.image.isNotEmpty
      ? NetworkImage(character.image)
      : null,
  child: character.image.isEmpty
      ? const Icon(Icons.person, size: 60)
      : null,
),
            const SizedBox(height: 16),
            Text('Status: ${character.status}', style: Theme.of(context).textTheme.titleMedium),
            Text('Species: ${character.species}', style: Theme.of(context).textTheme.bodyMedium),
            //Text('Gender: ${character.gender}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}