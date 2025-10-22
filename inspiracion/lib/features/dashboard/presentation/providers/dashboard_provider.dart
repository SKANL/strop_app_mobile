import 'package:flutter/foundation.dart';
import '../../../../domain/entities/dashboard_summary_entity.dart';
import '../../../../domain/usecases/get_dashboard_summary.dart';

class DashboardProvider extends ChangeNotifier {
  final GetDashboardSummary _getDashboardSummary;

  DashboardProvider(this._getDashboardSummary);

  bool _isLoading = false;
  DashboardSummary? _summary;
  String? _error;

  bool get isLoading => _isLoading;
  DashboardSummary? get summary => _summary;
  String? get error => _error;

  Future<void> fetchSummary() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _summary = await _getDashboardSummary.call();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}