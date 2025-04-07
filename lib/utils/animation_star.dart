import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randmapp/data/models/character_model.dart';

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
      duration: const Duration(milliseconds: 300),
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

  void _animateStar() {
    _animationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _animationController.reverse();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: widget.character.image,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(widget.character.name),
            subtitle: Text(
                '${widget.character.status} - ${widget.character.species}'),
            trailing: IconButton(
              icon: const Icon(Icons.star),
              onPressed: () {
                _animateStar();
                widget.onToggleFavorite();
              },
            ),
          ),
        );
      },
    );
  }
}
