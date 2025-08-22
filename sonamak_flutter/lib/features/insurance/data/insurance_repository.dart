
import 'package:sonamak_flutter/features/insurance/data/insurance_api.dart';
import 'package:sonamak_flutter/features/insurance/data/insurance_models.dart';

class InsuranceRepository {
  Future<List<InsuranceCompany>> listInsurances({int type = 1}) async {
    final res = await InsuranceApi.getInsurances(type: type);
    final list = res.data ?? const [];
    return list.whereType<Map<String, dynamic>>().map((e) => InsuranceCompany.fromJson(e)).toList(growable: false);
  }

  Future<bool> createInsurance(Map<String, dynamic> data) async {
    await InsuranceApi.createInsurance(data);
    return true;
  }

  Future<bool> updateInsurance(Map<String, dynamic> data) async {
    await InsuranceApi.updateInsurance(data);
    return true;
  }

  Future<bool> deleteInsurance(int id) async {
    await InsuranceApi.deleteInsurance(id);
    return true;
  }

  Future<List<InsuranceSegment>> segments(int insuranceId) async {
    final res = await InsuranceApi.getInsuranceClasses(insuranceId);
    final list = res.data ?? const [];
    return list.whereType<Map<String, dynamic>>().map((e) => InsuranceSegment.fromJson(e)).toList(growable: false);
  }

  Future<void> addSegment(Map<String, dynamic> data) => InsuranceApi.addSegmentInsurance(data);

  Future<List<ClaimItem>> claimData({required int insuranceId, String? from, String? to, required int claimStatus}) async {
    final res = await InsuranceApi.claimData(insuranceId: insuranceId, from: from, to: to, claimStatus: claimStatus);
    final list = res.data ?? const [];
    return list.whereType<Map<String, dynamic>>().map((e) => ClaimItem.fromJson(e)).toList(growable: false);
  }

  Future<void> generateClaim({required int insuranceId, required List<int> ids}) => InsuranceApi.generateClaim(insuranceId: insuranceId, ids: ids);

  Future<void> payClaim({required int insuranceId, required List<Map<String, dynamic>> claimed, dynamic paid}) =>
      InsuranceApi.payClaim(insuranceId: insuranceId, claimed: claimed, paid: paid);

  Future<List<PaymentRow>> payments(int insuranceId, int type) async {
    final res = await InsuranceApi.getInsurancePayments(insuranceId, type);
    final list = res.data ?? const [];
    return list.whereType<Map<String, dynamic>>().map((e) => PaymentRow(e)).toList(growable: false);
  }

  Future<void> downloadExcel({bool social = false}) async {
    if (social) {
      await InsuranceApi.socialInsuranceExcelDownload();
    } else {
      await InsuranceApi.insuranceExcelDownload();
    }
  }
}
