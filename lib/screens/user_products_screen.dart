import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

import '../providers/products_provider.dart';

import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';


class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator()) : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<ProductsProvider>(
            builder: (ctx, productsData, _) => Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (_, i) => Column(
                  children: [
                    UserProductItem(
                      productsData.items[i].id,
                      productsData.items[i].title,
                      productsData.items[i].imageUrl,
                    ),
                    Divider(),
                  ],
                ),
                itemCount: productsData.items.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
