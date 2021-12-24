import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/user_addresses_controller.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/account/address/widgets/address_field.dart';
import 'package:khanbuer_seller_re/widgets/line.dart';

import 'add_address/add_address.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои адреса'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              GetBuilder<UserAddressesController>(
                initState: (_) =>
                    Get.find<UserAddressesController>().getAddresses(),
                builder: (_) {
                  return _.addressEditStatus == AddressEditStatus.Loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const CustomLine(),
                          shrinkWrap: true,
                          itemCount: _.addresses.length,
                          itemBuilder: (context, index) =>
                              AddressField(_.addresses[index]),
                        );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () => Get.to(() => const AddAddress()),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.blueAccent,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 7),
                      child: const Text(
                        'Добавить \nадрес',
                        style: TextStyle(
                            fontSize: 18,
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
