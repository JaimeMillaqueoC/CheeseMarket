import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sisinfo/src/pages/formulario_page.dart';
import 'package:sisinfo/src/pages/drawer_page.dart';
import 'package:sisinfo/src/providers/productos_firebase.dart';
import 'package:sisinfo/src/providers/categoria_providers.dart';
import 'package:sisinfo/src/mywidgets/producto_Card.dart';

class Homepage extends StatefulWidget {
  static final route = "Home_page";
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        title: Text("Stock de quesos"),
      ),
      drawer: DrawerPage(),
      body: FutureBuilder(
        future: ProductosFirebase().productos,
        builder: (BuildContext contexto, AsyncSnapshot respuesta) {
          if (respuesta.hasData) {
            return respuesta.data.isNotEmpty
                ? ListView(
                    padding: EdgeInsets.all(10.0),
                    children: _crearItem(context, respuesta.data),
                  )
                : ListView(
                    padding: EdgeInsets.all(10.0),
                    children: _crearVacio(),
                  );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      
    );
  }
  Card _agregarCard({bool local, }){
    return Card(
      elevation: 15.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(10.0),
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FormularioPage(
                      edit: false,
                      local: local,
                      historial: false,
                    )));
            
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.all(12),
                title: Text(
                  "Agregar Quesos (+)",
                  style: TextStyle(fontSize: 27.0,color: Colors.purple[300]),
                ),
              ),
            ],
          )),
    );
  }
  List<Widget> _crearVacio({String tipo}){
    /*var format=DateFormat("dd/MM/yyyy").format(DateTime.now());
    List<String> date = format.split('/');
    List<int> diasPorMes = [31,28,31,30,31,30,31,31,30,31,30,31];
    int dia =int.parse(date[0]) ;
    int mes =int.parse(date[1]) ;
    int anio =int.parse(date[2]) ;
    DateTime(anio, 1 + 1, 0).day;
    int initDate = DateTime(2020,6,4).weekday;
      print(DateTime(anio, mes + 1, 0).day);*/
      
    List<Widget> _listaCard = [
      Container(
          color: Colors.orange[300],
          child: ListTile(
            title: Text(
              "Stock Regiones",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        _agregarCard(local: false),
        Container(
          color: Colors.orange[300],
          child: ListTile(
            title: Text(
              "Stock Local",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        _agregarCard(local: true),
    ];
   return _listaCard;
  }
  List<Widget> _crearItem(
    
      BuildContext context, List<Map<String, dynamic>> productosP) {
    List<String> categorias = Categoriaproviders().categorias;
    List<Map<String, dynamic>> productosCat = [];
    Map<String, dynamic> proCat={};
    List<Widget> _listaCard = [];
    List<String> categoriasEncontradas = [];
    productosP.forEach((element) {
      for (String cat in categorias) {
        if (_existCategoria(cat, element)) {
          productosCat.add(element[cat]);
          categoriasEncontradas.add(cat);
        }else{
          productosCat.add(null);
        }
      }
    });
    int index=0;
    bool flag=true;
    
    productosCat.forEach((element) { 
      if(index==0){
        flag=false;
      }else{
        flag=true;
      }
      if(element==null){
        _listaCard.add(
        Container(
          color: Colors.orange[300],
          child: ListTile(
            title: Text(
              "${categorias[index++]}",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "0 productos",
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
          ),
        ),
      );
      }
      else{
        _listaCard.add(
        Container(
          color: Colors.orange[400],
          child: ListTile(
            title: Text(
              "${categorias[index]}",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${element.length} productos",
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
          ),
        ),
      );
      
      element.forEach((key, value) {
        //SET CARD HERE!
        int precioTotalProductoC = (value['pesoKg'] * value['precio']).round();
        String nombre="";
        if(!flag){
          nombre=value['nombre'];
        }
        _listaCard.add(ProductoCard(
          nombreA: nombre,
          peso: value['pesoKg'],
          precioKg: value['precio'],
          precioTotalProductoKg: precioTotalProductoC,
          cantidadA: value['cantidad'],
          categoria: categorias[index],
          id: key,
          local: flag,
          historial: true,
        )
        );
        });
        index++;
      }
      _listaCard.add(_agregarCard(local: flag),);
    });
 
    return _listaCard;
  }

  bool _existCategoria(String cat, Map<String, dynamic> element) {
    List<dynamic> aux = [];
    try {
      aux.add(element[cat]);
    } catch (e) {}
    if (aux[0] == null) {
      return false;
    } else {
      return true;
    }
  }
}
