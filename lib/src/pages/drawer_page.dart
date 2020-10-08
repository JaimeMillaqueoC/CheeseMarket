import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.shopping_basket,
              text: 'Stock actual',
              onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.pushReplacementNamed(context, 'Home_page')
                  }),
          _createDrawerItem(
              icon: Icons.history,
              text: 'Historial de entregas',
              onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.pushReplacementNamed(context, "Historial_page")
                  }),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          )
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Cheese Market",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            )
          ],
        ));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(padding: EdgeInsets.only(left: 8.0), child: Text(text))
        ],
      ),
      onTap: onTap,
    );
  }
}
