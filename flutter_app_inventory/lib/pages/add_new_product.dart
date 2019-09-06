import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class AddNewProduct extends StatefulWidget {
  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _titleDispose = FocusNode();
  final _priceDispose = FocusNode();
  final _descriptionDispose = FocusNode();

  final _titleController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _form = GlobalKey<FormState>(); // membuat global key untuk form
  var _isLoading = false;
  var _initValue = true;
  String id;

  @override
  void didChangeDependencies() async {
    // ketika terjadi perubahan, fungsi dijalankan
    if(_initValue) {
      setState(() {
        _isLoading = true;
      });

      //mengambil id yang dikirim jika ada
      id =  ModalRoute.of(context).settings.arguments as String;
      if(id != null) {
        final response = await Provider.of<Products>(context).findById(id);
        _titleController.text = response.title;
        _stockController.text = response.stock.toString();
        _descriptionController.text = response.description;
      }

      setState(() {
        _isLoading = false;
      });
    }

    _initValue = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleDispose.dispose();
    _priceDispose.dispose();
    _descriptionDispose.dispose();
    super.dispose();
  }

  // fungsi submit/simpan data
  Future<void> _submit() async {
    final isValid = _form.currentState.validate();

    if(!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if(id == null) {
      await Provider.of<Products>(context, listen: false)
          .addProduct(
            ProductItem(
              id: null,
              title: _titleController.text,
              stock: int.parse(_stockController.text),
              description: _descriptionController.text
            )
      );
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(
            ProductItem(
                id: id,
                title: _titleController.text,
                stock: int.parse(_stockController.text),
                description: _descriptionController.text
            )
      );
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id == null ? 'Tambah orang Baru':'Ubah Orang'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submit,
          )
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Nama orang'
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceDispose);
                },
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Orang pasti punya nama, tolong diisi';
                  }
                  return null;
                },
                controller: _titleController,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Umur'
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionDispose);
                },
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Umur Tidak Boleh Kosong!';
                  }
                  if(int.tryParse(value) == null) {
                    return 'Umur Harus Berisi Angka';
                  }
                  if(int.parse(value) <= 0) {
                    return 'Umur Minimal 1, 0 mah mati dong apalagi negatif, hutang umur dong dia';
                  }
                  return null;
                },
                controller: _stockController,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Deskripsi'
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Deskripsi orang Harus Diisi';
                  }
                  return null;
                },
                controller: _descriptionController,
              ),


            ],
          ),
        ),
      )
      ,
    );
  }
}
