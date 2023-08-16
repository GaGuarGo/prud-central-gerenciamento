import 'package:flutter/material.dart';
import 'package:prud_gerenciamento/blocs/pedidosArroz/pedidosArroz_bloc.dart';
import 'package:prud_gerenciamento/blocs/pedidosArroz/pedidosArroz_tab.dart';

class PedidosArrozScreen extends StatefulWidget {
  @override
  _PedidosArrozScreenState createState() => _PedidosArrozScreenState();
}

class _PedidosArrozScreenState extends State<PedidosArrozScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pedidosArrozBloc = PedidosArrozBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      key: _scaffoldKey,
      body: StreamBuilder<List>(
        stream: _pedidosArrozBloc.outOrders,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          else
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    "N° de pedidos: ${snapshot.data.length}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Pesquisar',
                        hintStyle: TextStyle(color: Colors.white),
                        icon: Icon(Icons.search, color: Colors.white),
                        border: InputBorder.none),
                    onChanged: _pedidosArrozBloc.onChangedSearch,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return PedidosArrozTab(snapshot.data[index], _scaffoldKey);
                    },
                  ),
                ),
              ],
            );
        },
      ),
    );
  }
}
