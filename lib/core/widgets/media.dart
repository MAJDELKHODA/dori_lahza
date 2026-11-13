import 'package:cached_network_image/cached_network_image.dart';
import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Cached network image with a muted placeholder and an icon fallback.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = Radii.md,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image_outlined,
  });

  final String? url;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    Widget fallback() => Container(
          width: width,
          height: height,
          color: p.soft,
          alignment: Alignment.center,
          child: Icon(fallbackIcon, color: p.strong.withValues(alpha: 0.5)),
        );

    final image = url == null || url!.isEmpty
        ? fallback()
        : CachedNetworkImage(
            imageUrl: url!,
            width: width,
            height: height,
            fit: fit,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (_, _) => Container(width: width, height: height, color: p.surfaceMuted),
            errorWidget: (_, _, _) => fallback(),
          );
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: image);
  }
}

/// Circular avatar: photo when available, otherwise initials on [color].
class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.url, required this.initials, this.color, this.size = 48});

  final String? url;
  final String initials;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bg = color ?? p.strong;
    final placeholder = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg.withValues(alpha: 0.14), shape: BoxShape.circle),
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: 'Plex',
          fontWeight: FontWeight.w700,
          fontSize: size * 0.34,
          color: bg,
        ),
      ),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, _) => placeholder,
        errorWidget: (_, _, _) => placeholder,
      ),
    );
  }
}

/// Five stars with halves, read-only.
class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 16});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.palette.star;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final value = rating - i;
        final icon = value >= 0.75
            ? Icons.star_rounded
            : value >= 0.25
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded;
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}

/// Tappable five-star input.
class RatingInput extends StatelessWidget {
  const RatingInput({super.key, required this.value, required this.onChanged, this.size = 40});

  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final selected = i < value;
        return IconButton(
          onPressed: () => onChanged(i + 1),
          iconSize: size,
          tooltip: '${i + 1}',
          icon: AnimatedScale(
            scale: selected ? 1.08 : 1,
            duration: const Duration(milliseconds: 150),
            child: Icon(
              selected ? Icons.star_rounded : Icons.star_outline_rounded,
              color: selected ? p.star : p.border,
            ),
          ),
        );
      }),
    );
  }
}
