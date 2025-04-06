import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/blocs/character_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterInitial) {
            context.read<CharacterBloc>().add(FetchCharacters(page: 1));
            return const Center(child: Text('Initializing...'));
          } else if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterLoaded) {
            return ListView.builder(
              itemCount: state.characters.length,
              itemBuilder: (context, index) {
                final character = state.characters[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: character.image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(character.name),
                  subtitle: Text('${character.status} - ${character.species}'),
                  trailing: IconButton(
                    icon: Icon(
                        character.isFavorite ? Icons.star : Icons.star_border),
                    onPressed: () {
                      context
                          .read<CharacterBloc>()
                          .add(ToggleFavorite(character: character));
                    },
                  ),
                );
              },
            );
          } else if (state is CharacterError) {
            return Center(child: Text(state.message));
          } else if (state is CharacterUpdated) {
            return const Center(child: Text('Favorites updated!'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
