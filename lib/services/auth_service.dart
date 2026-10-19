import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _initAuthListener();
  }

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _initAuthListener() {
    if (SupabaseConfig.isConfigured) {
      try {
        final client = Supabase.instance.client;
        final currentSession = client.auth.currentSession;
        if (currentSession != null) {
          _setUserFromSupabase(currentSession.user);
        }

        client.auth.onAuthStateChange.listen((data) {
          final event = data.event;
          final session = data.session;

          if (session != null) {
            _setUserFromSupabase(session.user);
          } else if (event == AuthChangeEvent.signedOut) {
            _currentUser = null;
            notifyListeners();
          }
        });
      } catch (e) {
        debugPrint('Auth listener init: $e');
      }
    }
  }

  void _setUserFromSupabase(User user) {
    final meta = user.userMetadata ?? {};
    final fullName = meta['full_name'] as String? ??
        meta['name'] as String? ??
        meta['display_name'] as String? ??
        user.email?.split('@').first ??
        'Yang Mulia';

    _currentUser = UserModel(
      id: user.id,
      name: fullName,
      email: user.email ?? '',
      avatarUrl: meta['avatar_url'] as String?,
    );
    notifyListeners();
  }

  /// Masuk dengan Email & Kata Sandi
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (SupabaseConfig.isConfigured) {
        final res = await Supabase.instance.client.auth.signInWithPassword(
          email: email.trim(),
          password: password,
        );

        if (res.user != null) {
          _setUserFromSupabase(res.user!);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Gagal masuk. Periksa kembali email dan kata sandi Anda.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        // Fallback jika belum konek Supabase
        await Future.delayed(const Duration(milliseconds: 600));
        _currentUser = UserModel(
          id: 'usr_local_${DateTime.now().millisecondsSinceEpoch}',
          name: email.split('@').first,
          email: email,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on AuthException catch (e) {
      _isLoading = false;
      _errorMessage = _translateAuthError(e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Daftar Akun Baru dengan Email & Kata Sandi
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (SupabaseConfig.isConfigured) {
        final res = await Supabase.instance.client.auth.signUp(
          email: email.trim(),
          password: password,
          data: {'full_name': name.trim()},
        );

        if (res.user != null) {
          // Jika Supabase mengizinkan login langsung (tanpa verifikasi email)
          if (res.session != null) {
            _setUserFromSupabase(res.user!);
          } else {
            // Jika konfirmasi email aktif di Supabase
            _errorMessage =
                'Akun berhasil dibuat! Silakan periksa inbox email Anda untuk konfirmasi, atau matikan opsi "Confirm email" di dashboard Supabase agar bisa langsung masuk.';
          }
          _isLoading = false;
          notifyListeners();
          return res.session != null;
        } else {
          _errorMessage = 'Pendaftaran gagal.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 600));
        _currentUser = UserModel(
          id: 'usr_local_${DateTime.now().millisecondsSinceEpoch}',
          name: name.trim().isNotEmpty ? name.trim() : email.split('@').first,
          email: email,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on AuthException catch (e) {
      _isLoading = false;
      _errorMessage = _translateAuthError(e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Masuk Mode Pengujian Cepat
  Future<void> signInDemo() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = const UserModel(
      id: 'usr_yang_mulia_demo',
      name: 'Yang Mulia 👑',
      email: 'yangmulia@cashifly.app',
      avatarUrl: null,
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Keluar dari Akun
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (SupabaseConfig.isConfigured) {
        await Supabase.instance.client.auth.signOut();
      }
    } catch (e) {
      debugPrint('Error keluar akun: $e');
    }

    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  String _translateAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid login credentials')) {
      return 'Email atau kata sandi tidak sesuai.';
    }
    if (lower.contains('user already registered')) {
      return 'Email ini sudah terdaftar. Silakan pilih menu "Masuk".';
    }
    if (lower.contains('password should be at least')) {
      return 'Kata sandi minimal harus 6 karakter.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Email belum dikonfirmasi. Periksa kotak masuk email Anda.';
    }
    return message;
  }
}
