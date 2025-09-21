import 'package:hive/hive.dart';

class StorageService {
  final Box _box = Hive.box('historyBox');

  /// Salva um registro no histórico
  Future<void> save(Map<String, dynamic> data) async {
    await _box.add(Map<String, dynamic>.from(data));
  }

  /// Recupera todos os registros como lista de Map
  List<Map<String, dynamic>> getAll() {
    return _box.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// Recupera o último registro, se existir
  Map<String, dynamic>? getLast() {
    if (_box.isEmpty) return null;
    final last = _box.getAt(_box.length - 1);
    return last == null ? null : Map<String, dynamic>.from(last as Map);
  }

  /// Remove um registro específico baseado em comparação de campos
  Future<void> removeWhere(bool Function(Map<String, dynamic>) test) async {
    final keysToRemove = <dynamic>[];
    for (var i = 0; i < _box.length; i++) {
      final value = _box.getAt(i);
      if (value != null && test(Map<String, dynamic>.from(value as Map))) {
        keysToRemove.add(_box.keyAt(i));
      }
    }
    for (final key in keysToRemove) {
      await _box.delete(key);
    }
  }

  /// Limpa todo o histórico
  Future<void> clearAll() async {
    await _box.clear();
  }
}
