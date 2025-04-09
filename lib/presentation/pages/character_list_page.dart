import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/animation_star.dart';
import '../blocs/character/character_bloc.dart';
import '../blocs/theme/theme_bloc.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
        actions: [
          IconButton(
            icon: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Icon(
                  state is ThemeDark ? Icons.light_mode : Icons.dark_mode,
                );
              },
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
          ),
        ],
      ),
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
