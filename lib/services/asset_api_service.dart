import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../providers/asset_provider.dart';
import 'api_service.dart';

class AssetApiService {
  /// Get all assets
  static Future<List<Asset>> getAssets() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.assetsEndpoint}'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Asset.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load assets: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Get asset by ID
  static Future<Asset> getAssetById(String assetId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.assetByIdEndpoint(assetId)}'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Asset.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw ApiException('Asset not found');
      } else {
        throw ApiException('Failed to load asset: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Get asset types
  static Future<List<String>> getAssetTypes() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.assetTypesEndpoint}'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<String>();
      } else {
        throw ApiException('Failed to load asset types: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Get asset companies
  static Future<List<String>> getAssetCompanies() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.assetCompaniesEndpoint}'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<String>();
      } else {
        throw ApiException('Failed to load asset companies: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Create new asset
  static Future<Asset> createAsset(Asset asset) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.assetsEndpoint}'),
            headers: ApiConfig.defaultHeaders,
            body: json.encode(asset.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Asset.fromJson(jsonData);
      } else {
        throw ApiException('Failed to create asset: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Update asset
  static Future<Asset> updateAsset(Asset asset) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.assetByIdEndpoint(asset.id)}'),
            headers: ApiConfig.defaultHeaders,
            body: json.encode(asset.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Asset.fromJson(jsonData);
      } else {
        throw ApiException('Failed to update asset: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Delete asset
  static Future<void> deleteAsset(String assetId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.assetByIdEndpoint(assetId)}'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException('Failed to delete asset: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
