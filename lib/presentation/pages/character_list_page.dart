import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/animation_star.dart';
import '../blocs/character/character_bloc.dart';
import '../blocs/theme/theme_bloc.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  final ScrollController _scrollController = ScrollController();
  late final CharacterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<CharacterBloc>();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = _bloc.state;
    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 100 &&
        state is CharacterLoaded &&
        !state.isLoading &&
        !state.isLastPage) {
      _bloc.loadNextPage();
    }
  }

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
          if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.characters.length + (state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < state.characters.length) {
                  final character = state.characters[index];
                  return FavoriteItemTile(
                    character: character,
                    onToggleFavorite: () {
                      context
                          .read<CharacterBloc>()
                          .add(ToggleFavorite(character: character));
                    },
                  );
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          } else if (state is CharacterError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
