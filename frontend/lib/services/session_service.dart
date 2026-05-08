import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart'; // Import your ApiService

/// Simple in-memory session holder. Replace with `shared_preferences` /
/// secure storage when you wire the real API.
class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  String? currentRole; // 'CUSTOMER' | 'PROVIDER' | 'ADMIN'
  int? userId;
  String? displayName;
  String? email;

  bool get isLoggedIn => currentRole != null;

  void saveSession({
    required String role,
    int? userId,
    String? displayName,
    String? email,
  }) {
    currentRole = role.toUpperCase();
    this.userId = userId;
    this.displayName = displayName;
    this.email = email;
  }

  void clear() {
    currentRole = null;
    userId = null;
    displayName = null;
    email = null;
  }
  
  Future<void> logout() async {
      // 1. Notify the backend
      try {
        // FIX: Changed ApiService() to ApiService.instance
        await ApiService.instance.logoutBackend();
      } catch (e) {
        print("Could not reach backend for logout, proceeding with local logout.");
      }

      // 2. Clear persistent storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); 
      
      // 3. Clear in-memory variables
      clear(); 
  }
}