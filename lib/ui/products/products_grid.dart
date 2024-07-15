import 'products_manager.dart';
import './product_grid_tile.dart';
import '../../models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;
  final int type;

  const ProductsGrid(this.showFavorites, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products;
    if (type > 3) {
      products = context.select<ProductsManager, List<Product>>(
          (productsmanager) => showFavorites
              ? productsmanager.favoriteItems
              : productsmanager.items);
    } else {
      products = context.select<ProductsManager, List<Product>>(
          (productsmanager) => showFavorites
              ? productsmanager.getFavoriteProductsByType(type)
              : productsmanager.getProductsByType(type));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductGridTile(products[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
