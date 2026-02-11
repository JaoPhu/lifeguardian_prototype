import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../data/user_repository.dart';


class EditProfileScreen extends ConsumerStatefulWidget {
  final bool fromRegistration;
  const EditProfileScreen({super.key, this.fromRegistration = false});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _birthDateController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _medicalController;
  late TextEditingController _medicationsController;
  late TextEditingController _drugAllergiesController;
  late TextEditingController _foodAllergiesController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user.name);
    _usernameController = TextEditingController(text: user.username);
    _emailController = TextEditingController(text: user.email);
    _birthDateController = TextEditingController(text: user.birthDate);
    _ageController = TextEditingController(text: user.age);
    _genderController = TextEditingController(text: user.gender);
    _bloodTypeController = TextEditingController(text: user.bloodType);
    _heightController = TextEditingController(text: user.height);
    _weightController = TextEditingController(text: user.weight);
    _medicalController = TextEditingController(text: user.medicalCondition);
    _medicationsController = TextEditingController(text: user.currentMedications);
    _drugAllergiesController = TextEditingController(text: user.drugAllergies);
    _foodAllergiesController = TextEditingController(text: user.foodAllergies);
  }

  void _save() {
    final currentUser = ref.read(userProvider);
    String usernameText = _usernameController.text.trim();
    if (usernameText.startsWith('@')) {
      usernameText = usernameText.substring(1);
    }

    final updatedUser = currentUser.copyWith(
      name: _nameController.text,
      username: usernameText,
      email: _emailController.text,
      birthDate: _birthDateController.text,
      age: _ageController.text,
      gender: _genderController.text,
      bloodType: _bloodTypeController.text,
      height: _heightController.text,
      weight: _weightController.text,
      medicalCondition: _medicalController.text,
      currentMedications: _medicationsController.text,
      drugAllergies: _drugAllergiesController.text,
      foodAllergies: _foodAllergiesController.text,
    );
    ref.read(userProvider.notifier).updateUser(updatedUser);
    if (widget.fromRegistration) {
      context.go('/overview');
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.grey),
          onPressed: () => context.pop(),
        ),
        title: const Text('edit profile', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200, width: 2),
                        image: DecorationImage(
                          image: NetworkImage(user.avatarUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(LucideIcons.camera, size: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form
              _buildInputField('Name', _nameController),
              _buildInputField('Username', _usernameController),
              _buildInputField('Email', _emailController),
              
              Row(
                children: [
                  Expanded(child: _buildInputField('Birth Date', _birthDateController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInputField('Age', _ageController)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      'Gender',
                      _genderController.text,
                      ['Male', 'Female', 'Other'],
                      (value) => setState(() => _genderController.text = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'Blood Type',
                      // Normalize O+ to O etc. for display if needed, but the user said no +/-
                      _bloodTypeController.text.replaceAll('+', '').replaceAll('-', ''),
                      ['A', 'B', 'AB', 'O'],
                      (value) => setState(() => _bloodTypeController.text = value!),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildInputField('Height', _heightController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInputField('Weight', _weightController)),
                ],
              ),

              _buildInputField('Medical condition', _medicalController),
              _buildInputField('Current Medications', _medicationsController),
              _buildInputField('Drug Allergies', _drugAllergiesController),
              _buildInputField('Food Allergies', _foodAllergiesController),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D9488),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0D9488),
                        side: BorderSide.none,
                        backgroundColor: const Color(0xFFEEEEEE),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0D9488),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFEEEEEE),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: const Icon(LucideIcons.pencil, size: 16, color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, void Function(String?) onChanged) {
    // Ensure value is present in items or use null
    final String? selectedValue = items.contains(value) ? value : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0D9488),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: selectedValue,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFEEEEEE),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(LucideIcons.chevronDown, size: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
