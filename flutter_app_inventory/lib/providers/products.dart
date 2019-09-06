import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class untuk handle format data yang diinginkan
class ProductItem {
  final String id;
  final String title;
  final int stock;
  final String description;

  ProductItem(
  {
    @required this.id,
    @required this.title,
    @required this.stock,
    @required this.description
  });
}

// class untuk handle state management
class Products with ChangeNotifier {
  List<ProductItem> _items = []; // inisiasi

  // getter
  List<ProductItem> get items {
    return [..._items];
  }

  // ambil data dari server
  Future<void> fetchProduct() async {
    const url = 'https://first-firebase-99.firebaseio.com/products.json';
    final response = await http.get(url); // await untuk menunggu proses sebelum ke code selanjutnya
    final convertData = json.decode(response.body) as Map<String, dynamic>;
    final List<ProductItem> newData = [];

    // jika kosong, return untuk hentikan proses
    if(convertData == null) {
      return;
    }

    //jika tida kosong, insert data dari server ke newData
    convertData.forEach((key, value) {
      newData.add(ProductItem(
        id: key,
        title: value['title'],
        stock: value['stock'],
        description: value['description']
      ));
    });

    // data baru dimasukkan pada state
    _items = newData;
    notifyListeners(); // memberitahu ada data baru untuk widget akan di re-render
  }

  Future<ProductItem> findById(String id) async {
    final url = 'https://first-firebase-99.firebaseio.com/products/$id.json';
    final response = await http.get(url);
    final convert = json.decode(response.body);

    return ProductItem(
        id: id,
        title: convert['title'],
        description: convert['description'],
        stock: convert['stock']
    );
  }

  Future<ProductItem> addProduct(ProductItem product) async {
    final url = 'https://first-firebase-99.firebaseio.com/products.json';
    final response = await http.post(url,
      body: json.encode({
        'title': product.title,
        'stock': product.stock,
        'description': product.description
      }),
    );

    _items.add(
        ProductItem(
            id: json.decode(response.body)['name'],
            title: product.title,
            stock: product.stock,
            description: product.description
        )
    );

    notifyListeners();
  }

  //METHOD YG BERFUNGSI UNTUK MENGURANGI STOK BERDASARKAN ID
  Future<void> changeStock(String id) async {
    final url = 'https://first-firebase-99.firebaseio.com/products/$id.json';
    final index = _items.indexWhere((prod) => prod.id == id);
    final stock = _items[index].stock - 1;

    await http.patch(url, body: json.encode({'stock': stock})); //UPDATE DATA DI SERVER

    //DAN UPDATE JUGA DI LOCAL STATE
    _items[index] = ProductItem(
      id: id,
      title: _items[index].title,
      description: _items[index].description,
      stock: stock,
    );
    notifyListeners();
  }

  //METHOD INI UNTUK MENGUPDATE SEMUA INFORMASI DATA YANG SEDANG DI EDIT
  Future<void> updateProduct(ProductItem product) async {
    //BERDASARKAN ID PRODUCT
    final url = 'https://first-firebase-99.firebaseio.com/products/${product.id}.json';
    //KEMUDIAN KITA KIRIMKAN PARAMETER DATA YANG INGIN DI PERBAHARUI
    await http.patch(url, body: json.encode({
      'title': product.title,
      'stock': product.stock,
      'description': product.description
    }));
    //KEMUDIAN KITA UPDATE JUGA LOCAL STATE
    final index = _items.indexWhere((prod) => prod.id == product.id);
    _items[index] = product;
    notifyListeners();
  }

  //HAPUS PRODUK BERDASARKAN ID
  Future<void> removeProduct(String id) async {
    final url = 'https://first-firebase-99.firebaseio.com/products/$id.json';
    await http.delete(url); //KIRIM PERMINTAAN KE SERVER
    _items.removeWhere((prod) => prod.id == id); //DAN HAPUS JUGA PADA LOCAL STATE
    notifyListeners();
  }

}