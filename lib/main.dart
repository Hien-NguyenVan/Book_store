import 'ui/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthManager()),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsManager) {
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        ChangeNotifierProxyProvider<AuthManager, CartManager>(
          create: (ctx) => CartManager(),
          update: (ctx, authManager, cartManager) {
            cartManager!.authToken = authManager.authToken;
            return cartManager;
          },
        ),
        ChangeNotifierProxyProvider<AuthManager, OrdersManager>(
          create: (ctx) => OrdersManager(),
          update: (ctx, authManager, ordersManager) {
            ordersManager!.authToken = authManager.authToken;
            return ordersManager;
          },
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (context, authManager, child) {
          final colorScheme = ColorScheme.fromSwatch(
            primarySwatch: Colors.yellow,
          ).copyWith(
            secondary: Colors.deepOrange,
            background: Colors.white,
            surface: Colors.grey[200],
          );

          return MaterialApp(
            title: 'FASHION SHOP',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'YanoneKaffeesatz',
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              dialogTheme: DialogTheme(
                titleTextStyle: TextStyle(
                  color: colorScheme.onBackground,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                contentTextStyle: TextStyle(
                  color: colorScheme.onBackground,
                  fontSize: 20,
                ),
              ),
            ),
            home: authManager.isAuth() == 'User'
                ? const ProductsOverviewScreen()
                : authManager.isAuth() == 'Admin'
                    ? const UserProductsScreen()
                    : FutureBuilder(
                        future: authManager.tryAutoLogin(),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SplashScreen();
                          } else {
                            return const AuthScreen();
                          }
                        },
                      ),
            routes: {
              CartScreen.routeName: (ctx) =>
                  const SafeArea(child: CartScreen()),
              OrdersScreen.routeName: (ctx) =>
                  const SafeArea(child: OrdersScreen()),
              UserProductsScreen.routeName: (ctx) =>
                  const SafeArea(child: UserProductsScreen()),
              FindProductsScreen.routeName: (ctx) => const FindProductsScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == EditProductScreen.routeName) {
                final productId = settings.arguments as String?;
                return MaterialPageRoute(
                  builder: (ctx) => SafeArea(
                    child: EditProductScreen(
                      productId != null
                          ? ctx.read<ProductsManager>().findById(productId)
                          : null,
                    ),
                  ),
                );
              } else if (settings.name == ProductDetailScreen.routeName) {
                final productId = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (ctx) => SafeArea(
                    child: ProductDetailScreen(
                        ctx.read<ProductsManager>().findById(productId)!),
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
