import 'package:flutter/material.dart';

/// Maps the Lucide icon names the API sends (`category.icon`, `type.icon`)
/// to Material icons.
abstract final class IconMapper {
  static IconData fromName(String? name) => switch (name) {
        'building' || 'building-2' || 'hotel' => Icons.apartment_rounded,
        'calendar' || 'calendar-check' || 'calendar-days' => Icons.event_available_rounded,
        'camera' || 'aperture' => Icons.photo_camera_outlined,
        'scissors' => Icons.content_cut_rounded,
        'sparkles' || 'wand-sparkles' => Icons.auto_awesome_outlined,
        'flower' || 'flower-2' => Icons.local_florist_outlined,
        'palette' || 'paintbrush' || 'brush' => Icons.palette_outlined,
        'stethoscope' || 'heart-pulse' || 'activity' => Icons.medical_services_outlined,
        'tooth' || 'smile' => Icons.sentiment_satisfied_alt_outlined,
        'dumbbell' => Icons.fitness_center_rounded,
        'trophy' || 'goal' || 'volleyball' => Icons.sports_soccer_outlined,
        'car' => Icons.directions_car_outlined,
        'music' || 'mic' => Icons.music_note_outlined,
        'cake' || 'party-popper' || 'gift' => Icons.celebration_outlined,
        'utensils' || 'chef-hat' || 'coffee' => Icons.restaurant_outlined,
        'baby' => Icons.child_care_outlined,
        'graduation-cap' || 'book' || 'book-open' => Icons.school_outlined,
        'user' || 'users' => Icons.people_outline_rounded,
        'star' => Icons.star_outline_rounded,
        'heart' => Icons.favorite_border_rounded,
        'shirt' => Icons.checkroom_outlined,
        'home' || 'house' => Icons.home_outlined,
        'paw-print' || 'dog' || 'cat' => Icons.pets_outlined,
        _ => Icons.category_outlined,
      };
}
