import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductosFirebase{

  static final ProductosFirebase _instancia = ProductosFirebase._privado();
  ProductosFirebase._privado();
  
  factory ProductosFirebase(){
    return _instancia;
  }
  Future<List<Map<String, dynamic>>> get productos async{
    List<Map<String, dynamic>> productos =[];
    final resupuesta = await http.get("https://cheesemarket-c6f0e.firebaseio.com/.json");
    Map<String, dynamic> datos = jsonDecode(resupuesta.body);
    try{
      productos.add(datos['stocks']);
    }catch(e){
      productos=[];
    }
    if(productos[0]==null){
      productos=[];
    }
    return productos;
  }
  Future<List<Map<String, dynamic>>> getHistorial() async{
    List<Map<String, dynamic>> productos =[];
    final resupuesta = await http.get("https://cheesemarket-c6f0e.firebaseio.com/.json");
    Map<String, dynamic> datos = jsonDecode(resupuesta.body);
    try{
      productos.add(datos['historial']);
    }catch(e){
    }
    if(productos[0]==null){
      productos= [];
    }
    return productos;
  }
  Future<bool> agregarProductos(Map<String, dynamic> nuevoProducto, String categoria) async{
    final resupuesta = await http.post("https://cheesemarket-c6f0e.firebaseio.com/stocks/$categoria.json", body: json.encode(nuevoProducto));
  return true;
  }
  Future<bool> editarProducto (String page, Map<String, dynamic> producto, String id,String categoria)async{
    if(page=="historial"){
      final resupuesta = await http.put("https://cheesemarket-c6f0e.firebaseio.com/$page/$id.json", body: json.encode(producto));
    }else{
      final resupuesta = await http.put("https://cheesemarket-c6f0e.firebaseio.com/$page/$categoria/$id.json", body: json.encode(producto));
    }
    
  return true;
  }
  Future<bool> eliminarProducto (String page, String categoria,String id)async{
    if(page=="historial"){
      final resupuesta = await http.delete("https://cheesemarket-c6f0e.firebaseio.com/$page/$id.json");
    }else{
      final resupuesta = await http.delete("https://cheesemarket-c6f0e.firebaseio.com/$page/$categoria/$id.json");
    }
  return true;
  }
  Future<bool> agregarHistorial(Map<String, dynamic> nuevoProducto) async{
    final resupuesta = await http.post("https://cheesemarket-c6f0e.firebaseio.com/historial.json", body: json.encode(nuevoProducto));
  return true;
  }
}