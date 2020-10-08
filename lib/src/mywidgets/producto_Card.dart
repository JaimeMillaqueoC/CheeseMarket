import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sisinfo/src/pages/formulario_page.dart';
import 'package:sisinfo/src/providers/productos_firebase.dart';

class ProductoCard extends StatefulWidget {
  static String route = "/Producto";
  String nombreA;
  double peso;
  String categoriaA;
  int cantidad;
  int precioKg;
  int precioTotalKg;
  String id;
  bool local;
  bool historial;
  String fecha;
  ProductoCard(
      {String nombreA,
      double peso,
      int cantidadA,
      int precioTotalProductoKg,
      int precioKg,
      String categoria,
      String id,
      bool local,
      bool historial,
      String fecha
      }) {
    this.nombreA = nombreA;
    this.peso = peso;
    this.cantidad = cantidadA;
    this.precioKg = precioKg;
    this.precioTotalKg = precioTotalProductoKg;
    this.categoriaA = categoria;
    this.id = id;
    this.local = local;
    this.historial= historial;
    this.fecha=fecha;
  }
  /*Map toJson() => {
        "nombre":nombre,
        "cantidad": cantidad,
        "precio":preciox1 ,
        "precioTotal":precioTotalProducto
      };*/
  @override
  createState() => _ProductoCard();
}

class _ProductoCard extends State<ProductoCard> {
  String _nombreA;
  double _peso;
  int _cantidad;
  int _precioKg;
  int _precioTotalKg;
  String _categoriaA;
  String _fecha;
  String _id;
  bool _local;
  bool _historial;
  String page="stocks";
              
  @override
  void initState() {
    _nombreA = widget.nombreA;
    _peso = widget.peso;
    _cantidad = widget.cantidad;
    _precioKg = widget.precioKg;
    _precioTotalKg = widget.precioTotalKg;
    _categoriaA = widget.categoriaA;
    _id = widget.id;
    _local = widget.local;
    _historial= widget.historial;
    if(!_historial){
      page="historial";
      _fecha=widget.fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            String date= "";
            if(!_historial){
              date=_fecha;
            }
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FormularioPage(
                      nombreA: _nombreA,
                      cantidadA: _cantidad,
                      categoriaA: _categoriaA,
                      pesoKg: _peso,
                      preciox1A: _precioKg,
                      id: _id,
                      edit: true,
                      local: _local,
                      historial: !_historial,
                      fecha: date,
                    )));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _detail(local: _local),
          )),
    );
  }

  List<Widget> _detail({bool local}) {
    if (local) {
      return _localDetailCard();
    } else {
      return _regionDetailCard();
    }
  }

  List<Widget> _regionDetailCard() {
    List<Widget> aux= [
      ListTile(
        title: Text(
          "Para: $_nombreA",
          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
        ),
      ),
      ListTile(
        title: Text(
          "Valor lote: \$$_precioKg",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      ListTile(
        title: Text(
          "Kg. lote: $_peso kg",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      ListTile(
        title: Text(
          "Cantidad quesos: $_cantidad",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    ];
    if(!_historial){
      aux.add(ListTile(
        title: Text(
          "Fecha: $_fecha",
          style: TextStyle(fontSize: 18.0),
        ),
      ),);
    }
    aux.add(
      ButtonBar(children: <Widget>[
        _generarRaisedButton(crear: _historial),

        IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          tooltip: 'Borrar articulo',
          onPressed: () {
            if(!_historial){
              ProductosFirebase().eliminarProducto(page, _categoriaA, _id).then(
                (value) => Navigator.of(context)
    .pushNamedAndRemoveUntil('Historial_page', (Route<dynamic> route) => false));
            }else{
              ProductosFirebase().eliminarProducto(page, _categoriaA, _id).then(
                (value) => Navigator.of(context)
    .pushNamedAndRemoveUntil('Home_page', (Route<dynamic> route) => false));
            }
            
          },
        ),
      ])
    );
    return aux;
  }
  Widget _generarRaisedButton({bool crear}){
    if(crear){
      return RaisedButton(
          color: Colors.green[400],
            onPressed: () {
              var format=DateFormat("dd/MM/yyyy").format(DateTime.now());
              Map<String, dynamic> prodMap = {
                  "cantidad": _cantidad,
                  "pesoKg": _peso,
                  "precio": _precioKg,
                  "nombre":_nombreA,
                  "fecha":format
                };
              ProductosFirebase().agregarHistorial(prodMap);
              ProductosFirebase().eliminarProducto(page,_categoriaA, _id).then(
                (value) => Navigator.of(context)
    .pushNamedAndRemoveUntil('Home_page', (Route<dynamic> route) => false));
            },
            child: const Text('Confirmar entrega', style: TextStyle(fontSize: 20, color: Colors.white)),
          );
    }
    else{
      return Container();
    }
  }
  List<Widget> _localDetailCard() {
    List<Widget> detail = [
      ListTile(
        title: Text(
          "Peso: $_peso kg.       Precio: \$$_precioTotalKg ",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      ListTile(
        title: Text(
          "Valor kg: \$$_precioKg      Stock: $_cantidad",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      ButtonBar(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.minimize),
            color: Colors.blue,
            tooltip: 'Decrecer en 1 la cantidad de producto',
            onPressed: () {
              _cantidad--;
              if (_cantidad < 1) {
                _cantidad = 1;
              } else {
                Map<String, dynamic> prodMap = {
                  "cantidad": _cantidad,
                  "pesoKg": _peso,
                  "precio": _precioKg,
                };
                ProductosFirebase().editarProducto(page,prodMap, _id, _categoriaA);
              }
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.green,
            tooltip: 'Aumentar en 1 la cantidad de producto',
            onPressed: () {
              setState(() {
                _cantidad++;
                Map<String, dynamic> prodMap = {
                  "cantidad": _cantidad,
                  "pesoKg": _peso,
                  "precio": _precioKg,
                };
                ProductosFirebase().editarProducto(page,prodMap, _id, _categoriaA);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            tooltip: 'Borrar articulo',
            onPressed: () {
              
              ProductosFirebase().eliminarProducto(page,_categoriaA, _id).then(
                  (value) => Navigator.of(context)
    .pushNamedAndRemoveUntil('Home_page', (Route<dynamic> route) => false));
            },
          ),
        ],
      ),
    ];
    return detail;
  }
}
