import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatelessWidget {
  PageController pageController = PageController();

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            color: Colors.grey[800],
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: ListView(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only( right: 50, bottom: 50, left: 50),
                      child: Image.asset("images/logoazul.png",
                          width: 50,
                          height: 50,
                          alignment: Alignment.topCenter),
                    ),
                    Text(
                      'Gerenciamento',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Divider(
                        thickness: 2.0,
                      ),
                    )
                  ],
                ),
                DrawerTile(Icons.person, 'Usuários', pageController, 0),
                DrawerTile(
                Icons.reorder, 'Pedidos', pageController, 1),
                DrawerTile(Icons.list_sharp, 'Resumo do Dia', pageController, 2),
                DrawerTile(
                    Icons.textsms, 'Mensagens', pageController, 3),
                DrawerTile(
                    Icons.fastfood_rounded, 'Cardápio', pageController, 4)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  DrawerTile(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          pageController.jumpToPage(page);
          Navigator.of(context).pop();
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: pageController.page == page
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 16.0,
                    color: pageController.page.round() == page
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
