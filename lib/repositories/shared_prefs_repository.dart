import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Primitive provider for the SharedPreferences instance.
/// Intentionally left unimplemented to enforce synchronous injection during boot.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be explicitly overridden in main()');
});

/// Isolated data layer handling core key-value storage I/O operations.
class SharedPrefsRepository {
  final SharedPreferences _prefs;

  SharedPrefsRepository(this._prefs);

  /// Reads a string value from local storage. Returns null if key doesn't exist.
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Persists a string value asynchronously associated with a unique key.
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Removes an entry associated with a specific key.
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// Wipes all local persistence data from the device hardware scope.
  Future<bool> clear() async {
    return await _prefs.clear();
  }
}

/// Global read-only provider exposing the abstracted persistence repository.
final sharedPrefsRepositoryProvider = Provider<SharedPrefsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPrefsRepository(prefs);
});