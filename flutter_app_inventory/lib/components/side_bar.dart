import 'package:flutter/material.dart';
import 'package:flutter_app_inventory/pages/master_product_page.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Agetory: manajemen Umur'),
            automaticallyImplyLeading: false,
          ),
          Divider(), // garis pemisah
          ListTile(
            leading: Icon(Icons.people),
            title: Text('People'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.calendar_view_day),
            title: Text('Manajemen Umur'),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) =>
                  new MasterProductPage())
              );
//              Navigator.of(context).pushReplacementNamed('/manage-product');
            },
          ),
//          Divider(),
//          ListTile(
//            leading: Icon(Icons.lens),
//            title: Text('Tambah'),
//            onTap: () {
//              Navigator.of(context).pushReplacementNamed('/add-product');
//            },
//          )
        ],
      ),
    );
  }
}