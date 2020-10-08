import 'package:flutter/material.dart';
import 'package:sisinfo/src/pages/home_page.dart';
import 'package:sisinfo/src/providers/productos_firebase.dart';
import 'package:sisinfo/src/providers/categoria_providers.dart';
import 'package:sisinfo/src/utils/data.dart';

class FormularioPage extends StatefulWidget {
  static final route = "formulario";
  String nombreA;
  double pesoKg;
  String categoriaA;
  int cantidadA;
  int preciox1A;
  String id;
  bool edit;
  bool local;
  bool historial;
  String fecha;
  FormularioPage(
      {String nombreA,
      double pesoKg,
      int cantidadA,
      int preciox1A,
      String categoriaA,
      String id,
      bool edit: false,
      bool local,
      bool historial,
      String fecha
      }) {
    this.nombreA = nombreA;
    this.pesoKg = pesoKg;
    this.cantidadA = cantidadA;
    this.preciox1A = preciox1A;
    this.categoriaA = categoriaA;
    this.id = id;
    this.edit = edit;
    this.local = local;
    this.historial= historial;
    this.fecha=fecha;
  }
  @override
  _FormularioPageState createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  TextEditingController _nombreP = TextEditingController();
  TextEditingController _pesoKgP = TextEditingController();
  TextEditingController _precioP = TextEditingController();
  TextEditingController _cantidadP = TextEditingController();
  Map<String, dynamic> nuevoProducto = {};
  String helperTextI = "";

  String _nombreA;
  double _pesoKg;
  int _cantidadA;
  int _preciox1A;
  String _categoriaA;
  String _id;
  bool _edit;
  bool _local;
  bool _historial;
  String _fecha;
  String page = "stocks";
  String titulo="Agregar stock";
  @override
  void initState() {
    super.initState();
    _edit = widget.edit;
    _local = widget.local;
    _historial= widget.historial;
    if(_historial){
      page= "historial";
    }
    if (widget.edit) {
      _nombreA = widget.nombreA;
      _pesoKg = widget.pesoKg;
      _cantidadA = widget.cantidadA;
      _preciox1A = widget.preciox1A;
      _categoriaA = widget.categoriaA;
      _id = widget.id;
      titulo="Editar";
      if(_historial){
        _fecha = widget.fecha;
      }
      _loadDataSelectedCard();
    } else {
      _obtenerDatos(datos: ['pesokgP', 'precioP', "cantidadP"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/cheeselogo.png"),
                //fit: BoxFit.fill,
              ),
            ),
            child: null,
          ),
          Divider(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _tituloPagina(),
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 40.0,
                      color: Colors.blue[600]),
                )
              ],
            ),
          ),
          Container(child: _formato(local: _local)),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: () {
              if (_validarCampos()) {
                if (_edit) {
                  String ruta='Home_page';
                  Map<String, dynamic> prodMap = {};
                  if (_local) {
                    prodMap['pesoKg'] = double.parse(_pesoKgP.text);
                    prodMap['precio'] = int.parse(_precioP.text);
                    prodMap['cantidad'] = int.parse(_cantidadP.text);

                  } else {
                    if(_historial){
                      prodMap['nombre'] = _nombreP.text;
                    prodMap['pesoKg'] = double.parse(_pesoKgP.text);
                    prodMap['precio'] = int.parse(_precioP.text);
                    prodMap['cantidad'] = int.parse(_cantidadP.text);
                     prodMap['fecha'] = _fecha;
                     ruta='Historial_page';
                    }
                    else{
                      prodMap['nombre'] = _nombreP.text;
                    prodMap['pesoKg'] = double.parse(_pesoKgP.text);
                    prodMap['precio'] = int.parse(_precioP.text);
                    prodMap['cantidad'] = int.parse(_cantidadP.text);
                    }
                  }

                  ProductosFirebase()
                      .editarProducto(page,prodMap, _id, _categoriaA)
                      .then((value) => Navigator.of(context)
                          .pushNamedAndRemoveUntil(
                              ruta, (Route<dynamic> route) => false));
                } else {
                  _subirProducto(local: _local).then((value) =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'Home_page', (Route<dynamic> route) => false));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  bool _validarCampos() {
    if (_local) {
      if (_pesoKgP.text.isEmpty ||
          _precioP.text.isEmpty ||
          _cantidadP.text.isEmpty) {
        _showAlert(context);
        return false;
      } else {
        return true;
      }
    } else {
      if (_nombreP.text.isEmpty ||
          _pesoKgP.text.isEmpty ||
          _precioP.text.isEmpty ||
          _cantidadP.text.isEmpty) {
        _showAlert(context);
        return false;
      } else {
        return true;
      }
    }
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Formulario incompleto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Todos los campos son obligatorios, por favor llenelos."),
            ],
          ),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).requestFocus(new FocusNode());
              },
            ),
          ],
        );
      },
    );
  }

  Column _formato({bool local}) {
    if (local) {
      return _localForm();
    } else {
      return _regionForm();
    }
  }

  Column _regionForm() {
    return Column(
      children: [
        Divider(),
        _crearInput(
            controller: _nombreP,
            name: 'Nombre despacho',
            placeholder: 'Ingrese nombre despacho',
            kType: TextInputType.text),
        _crearInput(
            controller: _pesoKgP,
            name: 'Peso',
            placeholder: 'Peso pedido',
            kType: TextInputType.number),
        _crearInput(
          controller: _precioP,
          name: 'valor',
          placeholder: 'Ingrese el precio total',
          kType: TextInputType.number,
        ),
        _crearInput(
          controller: _cantidadP,
          name: 'Cantidad de quesos',
          placeholder: 'Ingrese cuantos quesos son',
          kType: TextInputType.number,
        ),
      ],
    );
  }

  Column _localForm() {
    return Column(
      children: [
        Divider(),
        _crearInput(
            controller: _pesoKgP,
            name: 'Peso',
            placeholder: 'Peso por unidad de queso',
            kType: TextInputType.number),
        Divider(),
        _crearInput(
          controller: _precioP,
          name: 'Precio kg',
          placeholder: 'Ingrese el precio del kg',
          kType: TextInputType.number,
        ),
        Divider(),
        _crearInput(
          controller: _cantidadP,
          name: 'Cantidad de quesos',
          placeholder: 'Ingrese cuantos quesos son',
          kType: TextInputType.number,
        ),
        Divider(),
      ],
    );
  }

  String _tituloPagina() {
    if (_edit) {
      return "Edite el stock";
    } else {
      return "Agregue";
    }
  }

  Widget _crearInput({
    TextEditingController controller,
    String name,
    String placeholder,
    TextInputType kType,
  }) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        keyboardType: kType,
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: name,
            hintText: placeholder,
            suffixIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.people),
            helperText: helperTextI,
            helperStyle: TextStyle(fontSize: 13.5, color: Colors.red)),
        onChanged: (value) => _guardarDatos(),
      ),
    );
  }

  Future<void> _loadDataSelectedCard() {
    _nombreP.text = _nombreA;
    _pesoKgP.text = _pesoKg.toString();
    _precioP.text = _preciox1A.toString();
    _cantidadP.text = _cantidadA.toString();
  }

  //Obtiene datos de shared preferences
  Future<void> _obtenerDatos({List<String> datos}) async {
    for (String productoDato in datos) {
      bool exist = await Data().checkData(productoDato);
      if (exist) {
        String datoObtenido = await Data().getData(productoDato);
        if (productoDato == 'pesokgP') {
          _pesoKgP.text = datoObtenido;
        }
        if (productoDato == 'precioP') {
          _precioP.text = datoObtenido;
        }
        if (productoDato == 'cantidadP') {
          _cantidadP.text = datoObtenido;
        }
      }
    }
    setState(() {});
  }

  //guarda datos en shared preferences
  void _guardarDatos() async {
    await Data().saveData('pesokgP', _pesoKgP.text);
    await Data().saveData('precioP', _precioP.text);
    await Data().saveData('cantidadP', _cantidadP.text);
    setState(() {});
  }

  Future<void> _subirProducto({bool local}) async {
    String car = "";
    
    if (_local) {
      nuevoProducto['pesoKg'] = double.parse(_pesoKgP.text);
      nuevoProducto['precio'] = int.parse(_precioP.text);
      nuevoProducto['cantidad'] = int.parse(_cantidadP.text);
      car = "VentaLocal";
    } else {
      nuevoProducto['nombre'] = _nombreP.text;
      nuevoProducto['pesoKg'] = double.parse(_pesoKgP.text);
      nuevoProducto['precio'] = int.parse(_precioP.text);
      nuevoProducto['cantidad'] = int.parse(_cantidadP.text);
      car = "VentaRegion";
    }
    bool resp = await ProductosFirebase().agregarProductos(nuevoProducto, car);
    /*bool resp = await ProductosFirebase()
        .agregarProductos(nuevoProducto, _selectedCategoria);*/
  }
}
