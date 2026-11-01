import 'package:flutter/foundation.dart';

abstract class BaseController<T> extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  T? _data;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  T? get data => _data;

  @protected
  void setLoading({required bool isLoading}) {
    _isLoading = isLoading;
    notifyListeners();
  }

  @protected
  void setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  @protected
  void setData(T data) {
    _data = data;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
