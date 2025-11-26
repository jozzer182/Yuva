import 'package:flutter/material.dart';
import 'package:yuva/l10n/app_localizations.dart';
import '../../core/avatar_constants.dart';
import '../colors.dart';
import '../typography.dart';

/// A widget that displays the current avatar and allows selection of a new one.
class AvatarPicker extends StatelessWidget {
  final String? selectedAvatarId;
  final String? fallbackInitial;
  final ValueChanged<String> onAvatarSelected;
  final double size;

  const AvatarPicker({
    super.key,
    this.selectedAvatarId,
    this.fallbackInitial,
    required this.onAvatarSelected,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Current avatar display
        GestureDetector(
          onTap: () => _showAvatarPicker(context),
          child: Stack(
            children: [
              _buildAvatar(context),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: YuvaColors.primaryTeal,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _showAvatarPicker(context),
          child: Text(
            l10n.avatarChange,
            style: YuvaTypography.bodySmall(color: YuvaColors.primaryTeal),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (selectedAvatarId != null && AvatarConstants.isValidAvatarId(selectedAvatarId)) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: AssetImage(AvatarConstants.getAssetPath(selectedAvatarId!)),
      );
    }
    
    // Fallback to initial
    final initial = (fallbackInitial?.isNotEmpty == true) 
        ? fallbackInitial!.substring(0, 1).toUpperCase() 
        : '?';
    
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
      child: Text(
        initial,
        style: YuvaTypography.hero(color: Colors.white),
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? YuvaColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.avatarSelectTitle,
                style: YuvaTypography.title(),
              ),
            ),
            // Avatar grid
            Expanded(
              child: GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: AvatarConstants.avatarIds.length,
                itemBuilder: (context, index) {
                  final avatarId = AvatarConstants.avatarIds[index];
                  final isSelected = avatarId == selectedAvatarId;
                  
                  return GestureDetector(
                    onTap: () {
                      onAvatarSelected(avatarId);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: YuvaColors.primaryTeal,
                                width: 3,
                              )
                            : null,
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          AvatarConstants.getAssetPath(avatarId),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple avatar display widget (no picker functionality)
class AvatarDisplay extends StatelessWidget {
  final String? avatarId;
  final String? fallbackInitial;
  final double size;

  const AvatarDisplay({
    super.key,
    this.avatarId,
    this.fallbackInitial,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (avatarId != null && AvatarConstants.isValidAvatarId(avatarId)) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: AssetImage(AvatarConstants.getAssetPath(avatarId!)),
      );
    }
    
    // Fallback to initial
    final initial = (fallbackInitial?.isNotEmpty == true) 
        ? fallbackInitial!.substring(0, 1).toUpperCase() 
        : '?';
    
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
