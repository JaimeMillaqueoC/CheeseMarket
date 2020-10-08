import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Data{
  //Comprobar si existen los datos
  Future<bool> checkData(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if((prefs.getString(name) ?? null) != null){
      return true;
    }else{
      return false;
    }
  }
  //obtener
  Future<String> getData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString(name) ?? null);
  }
  //guardar
  Future<bool> saveData(String name, String theData) async{ 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, theData);
    bool exist = await checkData(name);
    return exist;
  }
  //eliminar
  Future<bool> deleteData(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(name);
    bool removed = await checkData(name);
    return !removed;
  }
}
 