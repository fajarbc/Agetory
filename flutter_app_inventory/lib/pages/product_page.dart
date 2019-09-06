import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../components/product_list.dart';
import '../components/side_bar.dart';

class ProductPage extends StatelessWidget {
  // load data terbaru
  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Orang'),
      ),
      drawer: SideBar(), // drawer untuk mengatur sidebar menu
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context), // fungsi dipanggil ketika pull down
        child: FutureBuilder(
          future: Provider.of<Products>(context, listen: false).fetchProduct(),
          builder: (ctx, snapshop) {
            // saat masih loading
            if(snapshop.connectionState == ConnectionState.waiting) {
              // membuat widget loading
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // jika ada error
              if(snapshop.error != null) {
                return Center(
                  child: Text("Error Loading Data"),
                );
              } else {
                // loading selesai, tanpa error
                // ambil state product
                return Consumer<Products>(
                  builder: (ctx, product, child) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: product.items.length,
                        itemBuilder: (ctx, i) => ProductList(
                          product.items[i].id,
                          product.items[i].title,
                          product.items[i].stock,
                          product.items[i].description,
                          false
                        )
                    ),
                  )
                );
              }
            }
          }

          )
      )
    );
  }
}