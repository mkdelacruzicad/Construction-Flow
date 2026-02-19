import 'package:flutter/foundation.dart';

/// AppState holds simple in-memory auth + organization context.
/// This is a mock implementation suitable for UI wiring. No backend.
class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _role; // procurement, supplier, warehouse
  String? _companyId;
  String? _projectId;

  bool get isLoggedIn => _isLoggedIn;
  String? get role => _role;
  String? get companyId => _companyId;
  String? get projectId => _projectId;

  void login({required String email, required String password, bool rememberMe = false}) {
    // Mock success always
    _isLoggedIn = true;
    // If role already known from registration or prior session, keep it. Otherwise default to procurement
    _role ??= 'procurement';
    notifyListeners();
  }

  void register({required String fullName, required String email, required String phone, required String password, required String role}) {
    // Mock immediate register success and set role
    _role = role;
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Dev/testing: explicitly set current role and notify listeners.
  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _companyId = null;
    _projectId = null;
    _role = null;
    notifyListeners();
  }

  void selectCompany(String id) {
    _companyId = id;
    notifyListeners();
  }

  void selectProject(String id) {
    _projectId = id;
    notifyListeners();
  }
}
