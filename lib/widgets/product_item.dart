import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // retrieve the product here but don't change when the state chages
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product,
          ),
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // reload just the part affected from changing here (potentially create a new widget)
          leading: Consumer<Product>(
            // the third argument is a Widget/Widget tree inside the consumer that doesn't change
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              // doesn't work in another scaffold but take info from the closest scaffold
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Add item to cart!!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(label: 'UNDO', onPressed: (){
                    cart.removeSingleItem(product.id);
                  },),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
