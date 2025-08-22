
import 'package:sonamak_flutter/features/reports/data/reports_api.dart';

class ReportsRepository {
  // Excel exports
  Future<void> exportExamination({Map<String, dynamic>? params}) async => ReportsApi.examinationExcel(params: params);
  Future<void> exportPurchases({Map<String, dynamic>? params}) async => ReportsApi.purchasesExcel(params: params);
  Future<void> exportLaboratory({Map<String, dynamic>? params}) async => ReportsApi.laboratoryExcel(params: params);
  Future<void> exportLaboratoryDentist({Map<String, dynamic>? params}) async => ReportsApi.laboratoryDentistExcel(params: params);
  Future<void> exportPatients({Map<String, dynamic>? params}) async => ReportsApi.patientsExcel(params: params);
  Future<void> exportPatientsAbsent({Map<String, dynamic>? params}) async => ReportsApi.patientsAbsentExcel(params: params);
  Future<void> exportProcedures({Map<String, dynamic>? params}) async => ReportsApi.proceduresExcel(params: params);
  Future<void> exportStore({Map<String, dynamic>? params}) async => ReportsApi.storeExcel(params: params);
  Future<void> exportStoreExpire({Map<String, dynamic>? params}) async => ReportsApi.storeExpireExcel(params: params);
  Future<void> exportStorePayment({Map<String, dynamic>? params}) async => ReportsApi.storePaymentExcel(params: params);

  // Invoices / PDFs
  Future<Map<String, dynamic>> invoiceData({required dynamic id, required dynamic patientId, String? createdAt, dynamic invoice}) async {
    final res = await ReportsApi.invoiceData(id: id, patientId: patientId, createdAt: createdAt, invoice: invoice);
    return res.data ?? <String, dynamic>{};
  }

  Future<void> editInvoicePrice(Map<String, dynamic> data) async => ReportsApi.editInvoicePrice(data);
  Future<Map<String, dynamic>> billingInvoice(Map<String, dynamic> data) async {
    final res = await ReportsApi.billingInvoice(data);
    return res.data ?? <String, dynamic>{};
  }

  Future<void> examinationInvoice({Map<String, dynamic>? params}) async => ReportsApi.examinationInvoice(params: params);
}
