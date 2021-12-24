import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/all_bindings.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/account/account.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/my_shop_screen/my_shop_screen.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/shops_products_screen/shops_products_screen.dart';

import 'logo.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                height: 35,
              ),
              _createDrawerItem(
                icon: Icons.account_circle,
                text: user['email'] ??
                    user['unconfirmed_email'] ??
                    'buyer@gmail.com',
                onTap: () => Get.off(() => Account()),
              ),
              _createDrawerItem(
                icon: Icons.shop,
                text: 'Мой магазин',
                onTap: () => Get.off(
                  () => MyShopScreen(),
                  binding: MyShopBinding(),
                ),
              ),
              _createDrawerItem(
                icon: Icons.add_circle_outline,
                text: 'Добавить поставщика',
                onTap: () {},
              ),
              _createDrawerItem(
                  icon: Icons.thumbs_up_down_outlined,
                  text: 'Мои поставщики',
                  onTap: () {}),
              _createDrawerItem(
                icon: Icons.grid_view_outlined,
                text: 'Каталог всех поставщиков',
                onTap: () => Get.off(() => const ShopsProductsScreen(),
                    binding: ShopsProductsBinding()),
              ),
              _createDrawerItem(
                  icon: Icons.favorite_border,
                  text: 'Избранные товары',
                  onTap: () {}),
              _createDrawerItem(
                  icon: Icons.grading_outlined,
                  text: 'Мои заказы',
                  onTap: () {}),
              _cartDrawerItem(
                  icon: Icons.shopping_cart_outlined,
                  text: 'Корзина',
                  onTap: () {},
                  value: 2),
              _createDrawerItem(
                  icon: Icons.paid_outlined, text: 'Финансы', onTap: () {}),
              _createDrawerItem(
                  icon: Icons.settings,
                  text: 'Настройки',
                  onTap: () => Get.to(() => const ShopsProductsScreen(),
                      binding: ShopsProductsBinding())),
              const SizedBox(
                height: 30,
              ),
              _createDrawerItem(
                  icon: Icons.logout_outlined, text: 'Выход', onTap: () {}),
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
