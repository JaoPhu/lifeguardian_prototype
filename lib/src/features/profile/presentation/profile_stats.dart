import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileStats extends StatelessWidget {
  final String gender;
  final String bloodType;
  final int age;
  final int height;
  final int weight;

  const ProfileStats({
    super.key,
    required this.gender,
    required this.bloodType,
    required this.age,
    required this.height,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Gender', Icon(LucideIcons.smile, size: 24, color: const Color(0xFF4B5563))),
              _buildStatItem('Blood Type', Text(bloodType, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Age', Text('$age', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))),
              _buildStatItem('Height', Text('$height', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))),
              _buildStatItem('Weight', Text('$weight', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, Widget valueWidget) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 2),
        valueWidget,
      ],
    );
  }
}
