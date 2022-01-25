import 'package:flutter/material.dart';
import 'package:khanbuer_seller_re/widgets/drawer.dart';
import 'package:khanbuer_seller_re/widgets/logo.dart';

class SellerScreen extends StatelessWidget {
  SellerScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const LogoWidget(),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('Seller page'),
      ),
    );
  }
}
