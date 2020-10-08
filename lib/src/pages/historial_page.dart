import 'package:flutter/material.dart';
import 'package:sisinfo/src/pages/drawer_page.dart';
import 'package:sisinfo/src/providers/productos_firebase.dart';
import 'package:sisinfo/src/providers/categoria_providers.dart';
import 'package:sisinfo/src/mywidgets/producto_Card.dart';

class HistorialPage extends StatefulWidget {
  static final route = "Historial_page";
  @override
  HistorialPageState createState() => HistorialPageState();
}

class HistorialPageState extends State<HistorialPage> {
  List<String> meses;
  @override
  void initState() {
    super.initState();
    meses=["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre",];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        title: Text("Historial de ventas"),
      ),
      drawer: DrawerPage(),
      body: FutureBuilder(
        future: ProductosFirebase().getHistorial(),
        //initialData: [],
        builder: (BuildContext contexto, AsyncSnapshot respuesta) {
          if (respuesta.hasData) {
            return respuesta.data.isNotEmpty
                ? ListView(
                    padding: EdgeInsets.all(10.0),
                    children: _crearItem(context, respuesta.data),
                  )
                : Center(child: Text("Historial vacio :("));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


  List<Widget> _crearItem(
      BuildContext context, List<Map<String, dynamic>> productosP) {
    List<String> categorias = Categoriaproviders().categorias;
    List<Widget> _listaCard = [];
     List<Widget> alrevez=[];
    int ganancias=0;
    
    productosP.reversed.toList().forEach((element) { 
     
      int c= 0;
      element.forEach((key, value) {
        ganancias+=value['precio'];
       });
      _listaCard.add(Container(
          color: Colors.orange[400],
          child: ListTile(
            title: Text(
              "Ventas realizadas en regiones",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "entregas: ${element.length} || ganancias totales: \$$ganancias",
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
          ),
        ),);
        /*List<String> mesesEnc=[];
        element.forEach((key, value) { 
          List<String> date = value["fecha"].split('/');
          int mes = int.parse(date[1]);
          mesesEnc.add(meses[mes-1]);

        });
        print(mesesEnc);
        mesesEnc.forEach((element) { 

          
        });*/
        //elementos
        
        element.forEach((key, value) { 
          int precioTotalProductoC = (value['pesoKg'] * value['precio']).round();

          alrevez.add(ProductoCard(
          nombreA: value['nombre'],
          peso: value['pesoKg'],
          precioKg: value['precio'],
          precioTotalProductoKg: precioTotalProductoC,
          cantidadA: value['cantidad'],
          fecha: value["fecha"],
          categoria: categorias[0],
          id: key,
          local: false,
          historial: false,
        )
        );
        });
    });
    print(alrevez.reversed.toList());
    alrevez.reversed.toList().forEach((element) { 
      _listaCard.add(element);
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
