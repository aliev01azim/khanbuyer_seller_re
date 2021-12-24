import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/user_addresses_controller.dart';
import 'package:khanbuer_seller_re/helpers/alerts.dart';

class AddressField extends StatelessWidget {
  AddressField(this.address, {Key? key}) : super(key: key);
  final dynamic address;
  final _controller = Get.find<UserAddressesController>();
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) async {
        final result = await _controller.deleteAddress(address);
        if (result == true) {
          successAlertFromBottom('${address['id']} адрес был удалён');
        }
      },
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.delete,
                size: 40,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      child: ListTile(
        title: Text(address['country']! +
            ', г.' +
            address['city']! +
            ',\n' +
            'ул.' +
            address['full_address']!),
        subtitle: Text(address['phone_number']!),
        trailing: Text(address['recipient']! + '\n' + address['postcode']!),
      ),
    );
  }
}
