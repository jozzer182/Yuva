import 'package:flutter/material.dart';
import '../../core/avatar_constants.dart';
import '../colors.dart';

/// Widget reutilizable para mostrar el avatar de un usuario.
/// Si el avatarId es válido, muestra la imagen del avatar.
/// Si no, muestra un CircleAvatar con la inicial del nombre.
class UserAvatar extends StatelessWidget {
  final String? avatarId;
  final String displayName;
  final double radius;
  final Color? backgroundColor;

  const UserAvatar({
    super.key,
    this.avatarId,
    required this.displayName,
    this.radius = 28,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Si hay un avatarId válido, mostrar la imagen
    if (avatarId != null && AvatarConstants.isValidAvatarId(avatarId)) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(AvatarConstants.getAssetPath(avatarId!)),
        backgroundColor: backgroundColor ?? YuvaColors.primaryTeal,
      );
    }

    // Si no hay avatar válido, mostrar la inicial del nombre
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? YuvaColors.primaryTeal,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
