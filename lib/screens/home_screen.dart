import 'package:flutter/material.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';
import 'package:khanbuer_seller_re/widgets/drawer.dart';
import 'package:khanbuer_seller_re/widgets/logo.dart';

class BuyerScreen extends StatelessWidget {
  BuyerScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const LogoWidget(),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('Buyer page'),
      ),
    );
  }
}

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
