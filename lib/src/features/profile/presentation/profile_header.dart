import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onBack;
  final String title;

  const ProfileHeader({super.key, required this.onBack, this.title = 'Profile'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4, left: 4, right: 12, bottom: 2),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(LucideIcons.arrowLeft, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }
}
