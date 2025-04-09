import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';

class FavoriteItemTile extends StatefulWidget {
  final Character character;
  final VoidCallback onToggleFavorite;

  const FavoriteItemTile({
    super.key,
    required this.character,
    required this.onToggleFavorite,
  });

  @override
  State<FavoriteItemTile> createState() => _FavoriteItemTileState();
}

class _FavoriteItemTileState extends State<FavoriteItemTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _animateStar() async {
    await _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _animationController.reverse();

    widget.onToggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.character.image),
            ),
            title: Text(widget.character.name),
            subtitle: Text(
                '${widget.character.status} - ${widget.character.species}'),
            trailing: IconButton(
              icon: Icon(
                widget.character.isFavorite ? Icons.star : Icons.star_border,
              ),
              onPressed: () {
                _animateStar();
              },
            ),
          ),
        );
      },
    );
  }
}
