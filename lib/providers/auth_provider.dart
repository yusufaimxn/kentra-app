import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _firebaseService.auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final UserCredential? credential = await _firebaseService.signInWithEmailAndPassword(email, password);
      
      if (credential?.user != null) {
        _user = credential!.user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Sign in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Create account with email and password
  Future<bool> createUserWithEmailAndPassword(String email, String password, {
    String? displayName,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final UserCredential? credential = await _firebaseService.createUserWithEmailAndPassword(email, password);
      
      if (credential?.user != null) {
        _user = credential!.user;
        
        // Update display name if provided
        if (displayName != null) {
          await _user!.updateDisplayName(displayName);
        }
        
        // Create user profile in Firestore
        await _createUserProfile();
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Account creation failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _firebaseService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _firebaseService.resetPassword(email);
      return true;
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (_user != null) {
        if (displayName != null) {
          await _user!.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await _user!.updatePhotoURL(photoURL);
        }
        
        // Update user profile in Firestore
        await _updateUserProfile({
          if (displayName != null) 'displayName': displayName,
          if (photoURL != null) 'photoURL': photoURL,
        });
        
        // Reload user to get updated info
        await _user!.reload();
        _user = _firebaseService.auth.currentUser;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    try {
      _setLoading(true);
      _clearError();

      if (_user != null) {
        // Delete user data from Firestore
        await _firebaseService.deleteDocument('users', _user!.uid);
        
        // Delete Firebase Auth account
        await _user!.delete();
        _user = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Account deletion failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reauthenticate user (required for sensitive operations)
  Future<bool> reauthenticate(String password) async {
    try {
      _setLoading(true);
      _clearError();

      if (_user != null && _user!.email != null) {
        final AuthCredential credential = EmailAuthProvider.credential(
          email: _user!.email!,
          password: password,
        );
        
        await _user!.reauthenticateWithCredential(credential);
        return true;
      }
      return false;
    } catch (e) {
      _setError('Reauthentication failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Private helper methods
  Future<void> _createUserProfile() async {
    if (_user != null) {
      final Map<String, dynamic> userData = {
        'uid': _user!.uid,
        'email': _user!.email,
        'displayName': _user!.displayName,
        'photoURL': _user!.photoURL,
        'emailVerified': _user!.emailVerified,
        'onboardingCompleted': false,
        'preferences': {
          'theme': 'system',
          'notifications': true,
          'language': 'en',
        },
        'gamification': {
          'level': 1,
          'xp': 0,
          'streaks': {},
          'badges': [],
        },
      };

      await _firebaseService.createUserProfile(_user!.uid, userData);
    }
  }

  Future<void> _updateUserProfile(Map<String, dynamic> updates) async {
    if (_user != null) {
      await _firebaseService.updateUserProfile(_user!.uid, updates);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _clearError();
  }
}
