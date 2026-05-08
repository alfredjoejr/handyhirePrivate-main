import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

class ProviderVerificationScreen extends StatefulWidget {
  const ProviderVerificationScreen({super.key});

  @override
  State<ProviderVerificationScreen> createState() => _ProviderVerificationScreenState();
}

class _ProviderVerificationScreenState extends State<ProviderVerificationScreen> {
  List<dynamic> _pendingUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingUsers();
  }

  Future<void> _fetchPendingUsers() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.instance.getPendingUsers();
      // The backend returns a list, which our wrapper might put in 'data'
      setState(() {
        _pendingUsers = response['data'] ?? response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading users: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _processDecision(int userId, String action, String name) async {
    try {
      if (action == 'Approved') {
        await ApiService.instance.approveUser(userId);
      } else {
        await ApiService.instance.rejectUser(userId);
      }

      setState(() => _pendingUsers.removeWhere((u) => u['id'] == userId));
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name was $action.'),
          backgroundColor: action == 'Approved' ? Colors.green : Colors.redAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showActionDialog(int id, String name, bool isApprove) {
    final actionStr = isApprove ? 'Approve' : 'Deny';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E355B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('$actionStr User',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to ${actionStr.toLowerCase()} $name?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF8EBBFF)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: isApprove ? Colors.green : Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              _processDecision(id, isApprove ? 'Approved' : 'Denied', name);
            },
            child: const Text('Confirm',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('User Verification',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: const Color(0xFFB18E44))),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFB18E44)))
            : _pendingUsers.isEmpty
                ? const Center(
                    child: Text('No users waiting for verification.',
                        style: TextStyle(color: Colors.white70, fontSize: 18)))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _pendingUsers.length,
                    itemBuilder: (context, index) {
                      final user = _pendingUsers[index];
                      // Join roles (e.g. CUSTOMER, PROVIDER) into a clean string
                      final roles = (user['roles'] as List<dynamic>?)?.join(', ') ?? 'USER';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E355B),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFFC0C0C2).withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user['name'] ?? 'Unknown',
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  const SizedBox(height: 5),
                                  Text('Role: $roles',
                                      style: const TextStyle(color: Colors.white70)),
                                  const SizedBox(height: 5),
                                  Text('Email: ${user['email']}',
                                      style: const TextStyle(color: Color(0xFF8EBBFF), fontSize: 12)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                                  child: IconButton(
                                    icon: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                                    onPressed: () => _showActionDialog(user['id'], user['name'] ?? 'Unknown', true),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.1), shape: BoxShape.circle),
                                  child: IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 28),
                                    onPressed: () => _showActionDialog(user['id'], user['name'] ?? 'Unknown', false),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}