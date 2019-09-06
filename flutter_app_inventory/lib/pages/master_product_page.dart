import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/side_bar.dart';
import '../components/product_list.dart';
import '../providers/products.dart';

class MasterProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // load data barang
    Future<void> _fetchData(BuildContext context) async {
      await Provider.of<Products>(context, listen: false).fetchProduct();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Manajemen Orang"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/add-product');
            },
          )
        ],
      ),
      drawer: SideBar(),
      body: FutureBuilder(
        future: Provider.of<Products>(context, listen: false).fetchProduct(),
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if(snapshot.error != null) {
              return Center(
                child: Text("Error Loading Data huhu"),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: RefreshIndicator(
                  onRefresh: () => _fetchData(context),
                  child: Consumer<Products>(
                    builder: (context, product, child) => ListView.builder(
                      itemCount: product.items.length,
                      itemBuilder: (ctx, i) => ProductList(
                        product.items[i].id,
                        product.items[i].title,
                        product.items[i].stock,
                        product.items[i].description,
                        true
                      ),
                    ),
                  ),
                ),

              );
            }
          }
        },
      )
    );
  }
}