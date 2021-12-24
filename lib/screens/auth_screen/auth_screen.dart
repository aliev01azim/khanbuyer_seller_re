import 'package:flutter/material.dart';

// import './widgets/login_form.dart';
import './widgets/register_form.dart';

class AuthScreen extends StatelessWidget {
  final dynamic props;

  const AuthScreen({Key? key, this.props}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
            ),
            child: const Text(
              'KhanBuyer',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Alata',
                color: Colors.black,
              ),
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            indicatorWeight: 3,
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
            tabs: [
              Tab(text: 'ВХОД'),
              Tab(text: 'РЕГИСТРАЦИЯ'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            // LoginForm(),
            RegisterForm(),
          ],
        ),
      ),
    );
  }
}
