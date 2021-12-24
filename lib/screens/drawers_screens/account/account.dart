import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/widgets/drawer.dart';
import 'package:khanbuer_seller_re/widgets/list_tile.dart';

import 'user_data/user_data.dart';

class Account extends StatelessWidget {
  Account({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      key: _globalKey,
      appBar: AppBar(
        title: const Text('Аккаунт'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomListTile(
                onTap: () => Get.to(
                  () => const MyDataScreen(),
                ),
                title: 'Мои данные',
              ),
              // CustomListTile(
              //   onTap: () => Get.to(
              //     () => const AddressScreen(),
              //     binding: AddressesBinding(),
              //   ),
              //   title: 'Мои адреса',
              // ),

              CustomListTile(
                onTap: () => Get.to(
                  () => Account(),
                ),
                title: 'Выход',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
