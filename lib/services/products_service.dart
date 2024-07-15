import 'dart:convert';
import 'firebase_service.dart';
import '../models/product.dart';
import '../models/auth_token.dart';
// import 'package:http/http.dart' as http;
import 'package:diacritic/diacritic.dart';

class ProductsService extends FirebaseService {
  ProductsService([AuthToken? authToken]) : super(authToken);

  String removeDiacritic(String input) {
    return removeDiacritics(input).toLowerCase();
  }

  Future<List<Product>> fetchProducts() async {
    final List<Product> products = [];

    try {
      final productsMap =
          await httpFetch('$databaseUrl/products.json?auth=$token')
              as Map<String, dynamic>?;

      final userFavoritesMap =
          await httpFetch('$databaseUrl/userFavorites/$userId.json?auth=$token')
              as Map<String, dynamic>?;

      productsMap?.forEach((productId, product) {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[productId] ?? false);

        products.add(
          Product.fromJson({
            'id': productId,
            ...product,
          }).copyWith(isFavorite: isFavorite),
        );
      });

      return products;
    } catch (error) {
      print(error);
      return products;
    }
  }

  Future<List<Product>> fetchProductswithfind(String? title) async {
    final List<Product> products = [];

    try {
      final productsMap =
          await httpFetch('$databaseUrl/products.json?auth=$token')
              as Map<String, dynamic>?;

      final userFavoritesMap =
          await httpFetch('$databaseUrl/userFavorites/$userId.json?auth=$token')
              as Map<String, dynamic>?;

      productsMap?.forEach((productId, product) {
        String title1 = (product['title'] as String?) ?? "";

        String normalizedTitle = removeDiacritic(title1.toLowerCase());

        String normalizedSearchString = removeDiacritic(title!.toLowerCase());

        if (normalizedTitle.contains(normalizedSearchString)) {
          final isFavorite = (userFavoritesMap == null)
              ? false
              : (userFavoritesMap[productId] ?? false);
          products.add(
            Product.fromJson({
              'id': productId,
              ...product,
            }).copyWith(isFavorite: isFavorite),
          );
        }
      });
      return products;
    } catch (error) {
      print(error);
      return products;
    }
  }

  Future<Product?> addProduct(Product product) async {
    try {
      final newProduct = await httpFetch(
        '$databaseUrl/products.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          product.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      ) as Map<String, dynamic>?;

      return product.copyWith(
        id: newProduct!['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      await httpFetch(
        '$databaseUrl/products/${product.id}.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(product.toJson()),
      );
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      await httpFetch(
        '$databaseUrl/products/$id.json?auth=$token',
        method: HttpMethod.delete,
      );
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveFavoriteStatus(Product product) async {
    try {
      await httpFetch(
        '$databaseUrl/userFavorites/$userId/${product.id}.json?auth=$token',
        method: HttpMethod.put,
        body: jsonEncode(product.isFavorite),
      );
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
