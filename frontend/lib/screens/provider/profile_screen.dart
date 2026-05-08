import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../services/session_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  final TextEditingController _nameController =
      TextEditingController(text: 'Kasun Perera');
  final TextEditingController _phoneController =
      TextEditingController(text: '+94 77 123 4567');
  final TextEditingController _emailController =
      TextEditingController(text: 'kasun@email.com');
  final TextEditingController _locationController =
      TextEditingController(text: 'Kandy, Sri Lanka');
  final TextEditingController _skillsController =
      TextEditingController(text: 'Plumbing, Electrical, AC Repair');
  final TextEditingController _experienceController =
      TextEditingController(text: '5 years');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _skillsController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout(BuildContext context) async {
    await SessionService.instance.logout();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        if (_formKey.currentState!.validate()) {
          _isEditing = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } else {
        _isEditing = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('My Profile',
            style: TextStyle(
                color: AppColors.text, fontSize: 22, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _toggleEdit,
            child: Text(_isEditing ? 'Save' : 'Edit',
                style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                  border: Border.all(color: AppColors.accent, width: 3),
                ),
                child: const Icon(Icons.person, size: 65, color: AppColors.accent),
              ),
              const SizedBox(height: 10),
              if (!_isEditing)
                Text(_nameController.text,
                    style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  enabled: _isEditing),
              const SizedBox(height: 14),
              _buildField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  enabled: _isEditing,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 14),
              _buildField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  enabled: _isEditing,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              _buildField(
                  controller: _locationController,
                  label: 'Location',
                  icon: Icons.location_on,
                  enabled: _isEditing),
              const SizedBox(height: 14),
              _buildField(
                  controller: _skillsController,
                  label: 'Skills',
                  icon: Icons.build,
                  enabled: _isEditing),
              const SizedBox(height: 14),
              _buildField(
                  controller: _experienceController,
                  label: 'Experience',
                  icon: Icons.star,
                  enabled: _isEditing),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  // FIXED: Now properly calls your logout function!
                  onPressed: () => _handleLogout(context), 
                  icon: const Icon(Icons.logout, color: AppColors.danger),
                  label: const Text('Log Out',
                      style: TextStyle(
                          color: AppColors.danger,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.danger, width: 1.5),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        border: enabled
            ? Border.all(color: AppColors.accent, width: 1.5)
            : Border.all(color: Colors.transparent),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.text, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: AppColors.text.withOpacity(0.6), fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'This field cannot be empty';
          return null;
        },
      ),
    );
  }
}