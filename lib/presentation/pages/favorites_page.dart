import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randmapp/utils/animation_star.dart';
import '../../data/models/character_model.dart';
import '../blocs/character/character_bloc.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool _isSorted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: Icon(_isSorted ? Icons.sort_by_alpha : Icons.sort),
            onPressed: () {
              setState(() {
                _isSorted = !_isSorted;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoaded) {
            List<Character> favorites = state.characters
                .where((character) => character.isFavorite)
                .toList();

            if (_isSorted) {
              favorites.sort((a, b) => a.name.compareTo(b.name));
            }

            if (favorites.isEmpty) {
              return const Center(child: Text('No favorites yet'));
            }

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final character = favorites[index];
                return FavoriteItemTile(
                  character: character,
                  onToggleFavorite: () {
                    context
                        .read<CharacterBloc>()
                        .add(ToggleFavorite(character: character));
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
