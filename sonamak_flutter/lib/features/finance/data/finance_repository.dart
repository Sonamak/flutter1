import 'package:sonamak_flutter/features/finance/data/finance_api.dart';
import 'package:sonamak_flutter/features/finance/data/finance_models.dart';

class FinanceRepository {
  Future<List<BranchItem>> branches() async {
    final res = await FinanceApi.getTransactionBranches();
    final List<dynamic> list = res.data ?? const [];
    return list.whereType<Map<String, dynamic>>().map(BranchItem.fromJson).toList(growable: false);
  }

  Future<(List<FinanceRow>, List<IncomeCard>?)> allTransactions() async {
    final res = await FinanceApi.getTransactions();
    final List<dynamic> payload = res.data ?? const [];
    List<FinanceRow> tx = const [];
    List<IncomeCard>? incomes;
    if (payload.isNotEmpty) {
      final first = payload.first;
      if (first is List) {
        tx = first.whereType<Map<String, dynamic>>().map(FinanceRow.new).toList(growable: false);
        if (payload.length > 1 && payload[1] is List) {
          incomes = (payload[1] as List)
              .whereType<Map<String, dynamic>>()
              .map(IncomeCard.fromJson)
              .toList(growable: false);
        }
      } else {
        tx = payload.whereType<Map<String, dynamic>>().map(FinanceRow.new).toList(growable: false);
      }
    }
    return (tx, incomes);
  }

  Future<(List<FinanceRow>, List<IncomeCard>?)> search({
    String? event,
    String? date,
    String? filter,
    int? branchId,
    int? isVisa,
    int? visit,
    dynamic pdf,
  }) async {
    final res = await FinanceApi.searchTransactions(
      event: event,
      date: date,
      filter: filter,
      branchId: branchId,
      isVisa: isVisa,
      visit: visit,
      pdf: pdf,
    );
    final List<dynamic> payload = res.data ?? const [];
    List<FinanceRow> tx = const [];
    List<IncomeCard>? incomes;
    if (payload.isNotEmpty) {
      final first = payload.first;
      if (first is List) {
        tx = first.whereType<Map<String, dynamic>>().map(FinanceRow.new).toList(growable: false);
        if (payload.length > 1 && payload[1] is List) {
          incomes = (payload[1] as List)
              .whereType<Map<String, dynamic>>()
              .map(IncomeCard.fromJson)
              .toList(growable: false);
        }
      } else {
        tx = payload.whereType<Map<String, dynamic>>().map(FinanceRow.new).toList(growable: false);
      }
    }
    return (tx, incomes);
  }

  Future<void> saveCustody({required num amount, required int branchId}) {
    return FinanceApi.saveCustody(custody: amount, branchId: branchId);
  }

  Future<void> downloadExcel(Map<String, dynamic>? params) {
    return FinanceApi.transactionExcelDownload(params);
  }

  Future<Map<String, dynamic>> financialPdf({
    String? event,
    String? date,
    String? filter,
    int? branchId,
    int? isVisa,
    int? type,
  }) async {
    final res = await FinanceApi.financialPdf(
      event: event,
      date: date,
      filter: filter,
      branchId: branchId,
      isVisa: isVisa,
      type: type,
    );
    return res.data ?? <String, dynamic>{};
  }

  Future<PaymentSlipPageData> paymentSlip({required int userId, required int page, Map<String, dynamic>? filter}) async {
    final res = await FinanceApi.getPaymentSlip(userId: userId, page: page, filter: filter);
    return PaymentSlipPageData.fromJson(res.data ?? <String, dynamic>{});
  }

  Future<PaymentSlipPageData> searchSlip({
    required int userId,
    required int page,
    String? event,
    String? date,
    dynamic filter,
    int? branchId,
  }) async {
    final res = await FinanceApi.searchSlip(
      userId: userId,
      page: page,
      event: event,
      date: date,
      filter: filter,
      branchId: branchId,
    );
    return PaymentSlipPageData.fromJson(res.data ?? <String, dynamic>{});
  }
}
