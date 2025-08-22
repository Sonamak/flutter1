
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class StoreApi {
  static Future<Response<List<dynamic>>> getOrdersCards(dynamic filter) => HttpClient.I.get<List<dynamic>>('/orders/cards', queryParameters: filter is Map<String, dynamic> ? filter : null);
  static Future<Response<Map<String, dynamic>>> getOrderData(int id) => HttpClient.I.get<Map<String, dynamic>>('/orders/order', queryParameters: {'id': id});
  static Future<Response<dynamic>> changeOrderStatus(int id, String status) => HttpClient.I.post('/orders/change-status', data: {'id': id, 'status': status});
  static Future<Response<dynamic>> changeRefundStatus(int id, String status) => HttpClient.I.post('/orders/refund-status', data: {'id': id, 'status': status});
  static Future<Response<List<dynamic>>> getSubStores() => HttpClient.I.get<List<dynamic>>('/sub-stores');
  static Future<Response<List<dynamic>>> getProducts(Map<String, dynamic> q) => HttpClient.I.get<List<dynamic>>('/products', queryParameters: q);
  static Future<Response<dynamic>> insertProduct(Map<String, dynamic> data) => HttpClient.I.post('/products/insert', data: data);
}
