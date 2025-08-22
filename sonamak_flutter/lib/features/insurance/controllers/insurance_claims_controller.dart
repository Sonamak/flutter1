
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/insurance/data/insurance_models.dart';
import 'package:sonamak_flutter/features/insurance/data/insurance_repository.dart';

class InsuranceClaimsState {
  final bool loading;
  final List<ClaimItem> items;
  final Object? error;
  final String? from;
  final String? to;
  final int claimStatus;
  const InsuranceClaimsState({required this.loading, this.items = const [], this.error, this.from, this.to, this.claimStatus = 0});

  factory InsuranceClaimsState.initial() => const InsuranceClaimsState(loading: false);
}

class InsuranceClaimsController extends ChangeNotifier {
  InsuranceClaimsController(this._repo, {required this.insuranceId});
  final InsuranceRepository _repo;
  final int insuranceId;

  InsuranceClaimsState _state = InsuranceClaimsState.initial();
  InsuranceClaimsState get state => _state;

  Future<void> load({String? from, String? to, int claimStatus = 0}) async {
    _state = InsuranceClaimsState(loading: true, from: from, to: to, claimStatus: claimStatus);
    notifyListeners();
    try {
      final items = await _repo.claimData(insuranceId: insuranceId, from: from, to: to, claimStatus: claimStatus);
      _state = InsuranceClaimsState(loading: false, items: items, from: from, to: to, claimStatus: claimStatus);
      notifyListeners();
    } catch (e) {
      _state = InsuranceClaimsState(loading: false, items: const [], error: e, from: from, to: to, claimStatus: claimStatus);
      notifyListeners();
    }
  }

  Future<bool> generateClaim(List<int> ids) async {
    try {
      await _repo.generateClaim(insuranceId: insuranceId, ids: ids);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> payClaim({required List<Map<String, dynamic>> claimed, dynamic paid}) async {
    try {
      await _repo.payClaim(insuranceId: insuranceId, claimed: claimed, paid: paid);
      return true;
    } catch (_) {
      return false;
    }
  }
}
