import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Wrapper widget that constrains the app to a mobile-sized column on web.
/// This provides a better UX for the web demo version since the app is designed
/// for vertical mobile format.
/// On mobile platforms (including tablets), returns the child as-is to use full width.
class WebWrapper extends StatelessWidget {
  final Widget child;

  const WebWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Only apply the constraint on web platform
    if (kIsWeb) {
      return Container(
        color: Colors.black87,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: child,
          ),
        ),
      );
    }

    // On mobile platforms (including tablets), return the child as-is
    // This allows tablets to use the full screen width
    return child;
  }
}
