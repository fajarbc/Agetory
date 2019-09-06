import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductList extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final int stock;
  final bool type;

  // constructor
  ProductList(
      this.id,
      this.title,
      this.stock,
      this.description,
      this.type
      );

  @override
  Widget build(BuildContext context) {
    // Dismissible, ketika di geser akan melakukan action
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.call_missed_outgoing,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),

      // arah geser dari kanan ke kiri
      direction: DismissDirection.endToStart,
      //ketika digeser
      confirmDismiss: (dismiss) {
        // menampilkan dialog
        showDialog(context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Konfirmasi"),
            content: Text("Kamu akan mengurangi umurnya?"),
            actions: <Widget>[
              // ketika tombol dipencet, dialog ditutup
              FlatButton(
                child: Text(
                  "Ga Jadi",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),

              FlatButton(
                child: Text(
                  "Ya Dong",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              )
            ],
          )
        ).then((result) {
          // cek, jika true
          if(result) {
            // jika stock ada {
            if(stock > 0) {
              Provider.of<Products>(context, listen: false).changeStock(id);
            } else {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Umur dia udah habis :("),
                duration: Duration(seconds: 2),
              ));
            }
          }
        });
      },

      child: Card(
        elevation: 4,
        // listtile, terdapat Leading, Title, Trailing
        child: ListTile(
          // leading di render di kiri
          leading: CircleAvatar(
            child: Text(stock.toString()),
          ),
          title: Text(title),
          subtitle: Text(
            'Deskripsi: $description',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          // trailing di render di kanan
          trailing: !type
            ? Text(
                  stock > 0 ? 'Hidup' : 'Mati',
                  style: TextStyle(color: stock > 0 ? Colors.green : Colors.red)
            )
           : Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add-product', arguments: id);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Konfirmasi"),
                        content: Text("Proses ini akan membunuh orang"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "Batal",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),

                          FlatButton(
                            child: Text(
                              "Lanjutkan",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            onPressed: () {
                              Provider.of<Products>(context, listen: false)
                                  .removeProduct(id)
                                  .then((_) {
                                Navigator.of(context).pop(false);
                              });
                            },
                          ),

                        ],
                      ),
                    );
                  },
                  color: Theme.of(context).errorColor,
                )
              ],
            ),
          )   
          ,
        )
      ),

    );
  }


}