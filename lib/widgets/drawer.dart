import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khanbuer_seller_re/controllers/all_bindings.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/account/account.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/my_shop_screen/my_shop_screen.dart';
import 'package:khanbuer_seller_re/screens/start_screens/slider_screen.dart';

import '../screens/drawers_screens/my_shop_screen/add_product_screen/add_product_screen.dart';
import '../screens/drawers_screens/orders_screen/orders_screen.dart';
import 'logo.dart';

// ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map user = Hive.box('userBox').get('user', defaultValue: {});
    return Drawer(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              const LogoWidget(),
              const SizedBox(
                height: 15,
              ),
              _createDrawerItem(
                icon: Icons.account_circle,
                text: user['email'].isNotEmpty
                    ? user['email']
                    : user['unconfirmed_email'] ?? 'seller@gmail.com',
                onTap: () => Get.offAll(() => Account()),
              ),
              _createDrawerItem(
                icon: Icons.hail_outlined,
                text: 'Покупатели',
                onTap: () {},
              ),
              _createDrawerItem(
                icon: Icons.shop,
                text: 'Мой магазин',
                onTap: () => Get.offAll(() => MyShopScreen()),
              ),
              _createDrawerItem(
                icon: Icons.add_circle_outline,
                text: 'Добавить товар',
                onTap: () => Get.offAll(() => const AddProductScreen(),
                    arguments: {'isDrawer': true}),
              ),
              _createDrawerItem(
                icon: Icons.task_alt_outlined,
                text: 'Задачи',
                onTap: () {},
              ),
              _createDrawerItem(
                icon: Icons.grading_outlined,
                text: 'Заказы',
                onTap: () => Get.offAll(() => OrdersScreen()),
              ),
              _createDrawerItem(
                icon: Icons.paid_outlined,
                text: 'Финансы',
                onTap: () {},
              ),
              _createDrawerItem(
                icon: Icons.settings,
                text: 'Настройки',
                onTap: () {},
              ),
              const SizedBox(
                height: 30,
              ),
              _createDrawerItem(
                  icon: Icons.logout_outlined,
                  text: 'Выход',
                  onTap: () async {
                    await Hive.box('userBox').deleteFromDisk();
                    Get.offAll(const StartScreen());
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _cartDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap,
      required int value}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            width: 16,
            height: 16,
            child: Center(
              child: Text(
                value.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
