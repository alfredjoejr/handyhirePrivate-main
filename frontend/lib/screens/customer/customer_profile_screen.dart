import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../../services/session_service.dart';
import 'app_colors.dart'; // Assuming this is needed based on your AppColors references

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  bool _isEditing = false;

  final TextEditingController _nameController =
      TextEditingController(text: "Alex Johnson");
  final TextEditingController _emailController =
      TextEditingController(text: "alex.johnson@email.com");
  final TextEditingController _phoneController =
      TextEditingController(text: "+94 77 123 4567");
  final TextEditingController _addressController =
      TextEditingController(text: "45 Galle Road, Colombo 03");

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
      _isEditing = !_isEditing;
    });
  }

  // Moved the logout logic inside a proper method
  Future<void> _handleLogout() async {
    // Use the singleton instance
    await SessionService.instance.logout();

    // Ensure the widget is still in the tree before navigating
    if (!mounted) return;

    // Navigate back to Login and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          _buildStatsRow(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Personal Information",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: _toggleEdit,
                      icon: Icon(
                        _isEditing ? Icons.check : Icons.edit_outlined,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      label: Text(_isEditing ? "Save" : "Edit",
                          style: const TextStyle(color: AppColors.accent)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoField(Icons.person_outline, "Full Name", _nameController),
                _buildInfoField(Icons.email_outlined, "Email", _emailController),
                _buildInfoField(Icons.phone_outlined, "Phone", _phoneController),
                _buildInfoField(
                    Icons.location_on_outlined, "Address", _addressController),
                
                const SizedBox(height: 30),
                
                // ADDED LOGOUT BUTTON HERE
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Logout", 
                      style: TextStyle(color: Colors.white, fontSize: 16)
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 55,
            backgroundColor: AppColors.secondary,
            child: Icon(Icons.person, size: 70, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Text(
            _nameController.text,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            _emailController.text,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          color: AppColors.secondary, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem("4", "Jobs Done"),
          _verticalDivider(),
          _statItem("4.7", "Avg Given"),
          _verticalDivider(),
          _statItem("Rs. 9,800", "Total Spent"),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }

  Widget _verticalDivider() => Container(width: 1, height: 36, color: Colors.white10);

  Widget _buildInfoField(
      IconData icon, String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.secondary, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: _isEditing,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}