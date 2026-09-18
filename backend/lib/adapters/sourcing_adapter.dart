import '../models/product.dart';

abstract class SourcingAdapter {
  String get platformName;
  Future<List<UnifiedProduct>> searchProducts(String query, String freightType);
}
