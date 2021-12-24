import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/all_bindings.dart';
import 'package:khanbuer_seller_re/screens/start_screens/login_screen.dart';
import 'package:khanbuer_seller_re/widgets/list_tile.dart';

import 'mini_screens/date.dart';
import 'mini_screens/email.dart';
import 'mini_screens/fio.dart';
import 'mini_screens/gender.dart';

class MyDataScreen extends StatelessWidget {
  const MyDataScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои данные'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Icon(Icons.photo_camera),
                    ),
                  ),
                ),
              ),
              CustomUserListTile(
                  onTap: () =>
                      Get.to(() => const FIO(), binding: AuthBinding()),
                  title: 'Редактировать ФИО',
                  boxValue: 'full_name'),
              CustomUserListTile(
                onTap: () => Get.to(() => const Date(), binding: AuthBinding()),
                title: 'Дата рождения \nуказать',
                boxValue: 'birth_date',
              ),
              CustomUserListTile(
                onTap: () =>
                    Get.to(() => const Gender(), binding: AuthBinding()),
                title: 'Пол \nуказать',
                boxValue: 'gender',
              ),
              CustomUserListTile(
                onTap: () =>
                    Get.to(() => const LoginScreen(), binding: AuthBinding()),
                title: 'Ваш номер телефона',
                boxValue: 'username',
              ),
              CustomUserListTile(
                onTap: () =>
                    Get.to(() => const Email(), binding: AuthBinding()),
                title: 'Изменить email',
                boxValue: 'email',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
