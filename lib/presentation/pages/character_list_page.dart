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
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _loadMoreCharacters();
    }
  }

  void _loadMoreCharacters() {
    setState(() {
      _isLoadingMore = true;
    });

    context.read<CharacterBloc>().loadNextPage();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoadingMore = false;
      });
    });
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
          if (state is CharacterInitial) {
            context.read<CharacterBloc>().add(FetchCharacters(page: 1));
            return const Center(child: Text('Initializing...'));
          } else if (state is CharacterLoading && state is! CharacterLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.characters.length + (_isLoadingMore ? 1 : 0),
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
