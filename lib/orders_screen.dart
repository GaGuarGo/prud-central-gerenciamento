import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prud_gerenciamento/blocs/pedidosArroz/pedidosArroz_screen.dart';
import 'package:prud_gerenciamento/blocs/pedidosDia/pedidos_screen.dart';
import 'package:prud_gerenciamento/blocs/pedidosOvo/pedidoOvo_screen.dart';
import 'package:prud_gerenciamento/drawer.dart';

// ignore: must_be_immutable
class OrderScreen extends StatefulWidget {
  PageController pageController = PageController();
  OrderScreen(this.pageController);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _page = 0;

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(widget.pageController),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Pedidos de Almoço',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.blueAccent.shade700,
            primaryColor: Colors.white,
            textTheme: TextTheme(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (p) {
            _pageController.animateToPage(p,
                duration: Duration(microseconds: 500), curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Dia'),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Ovo'),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant), label: 'Arroz Integral'),
          ],
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (p) {
            setState(() {
              _page = p;
            });
          },
          children: [
            PedidosScreen(),
            PedidosOvoScreen(),
            PedidosArrozScreen(),
          ],
        ),
      ),
    );
  }
}
