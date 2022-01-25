import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khanbuer_seller_re/controllers/auth_controller.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';

class FIO extends StatefulWidget {
  const FIO({Key? key}) : super(key: key);

  @override
  State<FIO> createState() => _FIOState();
}

class _FIOState extends State<FIO> {
  String data = '';
  Map user = Hive.box('userBox').get('user', defaultValue: {});
  @override
  void initState() {
    if (user['full_name'] != null) {
      data = user['full_name'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ФИО'),
        actions: [
          GetBuilder<AuthController>(
            builder: (_) {
              final bool loading = _.userEditStatus == UserEditStatus.Loading;

              return IconButton(
                onPressed: user['full_name'] != data && data.isNotEmpty
                    ? () async {
                        _.editFio(data);
                      }
                    : null,
                icon: loading ? const IndicatorMini() : const Icon(Icons.done),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: TextFormField(
            autofocus: true,
            initialValue: data,
            onChanged: (val) {
              setState(() {
                data = val;
              });
            }),
      ),
    );
  }
}
