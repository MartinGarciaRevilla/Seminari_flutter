import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/UserService.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  User? _loggedInUser;
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  User? get loggedInUser => _loggedInUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  Future<void> loadUsers() async {
    _setLoading(true);
    _setError(null);

    try {
      _users = await UserService.getUsers();
    } catch (e) {
      _setError('Error loading users: $e');
      _users = [];
    } finally {
      _setLoading(false);
    }
  }
  

 void setLoggedInUser(User user) {
  _loggedInUser = user;
  notifyListeners();
}

 Future<bool> updateUser(User updatedUser) async {
  _setLoading(true);
  _setError(null);

  try {
    final user = await UserService.updateUser(updatedUser.id!, updatedUser);
    _loggedInUser = user; // Actualizar el usuario logueado
    notifyListeners();
    return true;
  } catch (e) {
    _setError('Error actualitzant usuari: $e');
    return false;
  } finally {
    _setLoading(false);
  }
}

  Future<bool> eliminarUsuariPerId(String userId) async {
  _setLoading(true);
  _setError(null);

  try {
    final success = await UserService.deleteUser(userId);
    if (success) {
      _users.removeWhere((user) => user.id == userId);
      notifyListeners();
      return true;
    } else {
      throw Exception('No s\'ha pogut eliminar l\'usuari');
    }
  } catch (e) {
    _setError('Error eliminant l\'usuari: $e');
    return false;
  } finally {
    _setLoading(false);
  }
}
}