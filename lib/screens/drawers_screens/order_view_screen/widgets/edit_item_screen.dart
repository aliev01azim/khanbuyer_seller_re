import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/helpers/colors.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import 'package:dio/dio.dart' as dio;

import '../../../../controllers/orders_controller.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({Key? key, this.item}) : super(key: key);
  final dynamic item;
  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _controller = Get.find<OrdersController>();

  void _handleSubmit() async {
    print(widget.item);
    // await _controller.editItem(formData, widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменить '),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            ...widget.item.map((c) {
              return RowItem(c);
            }).toList(),
            GetBuilder<OrdersController>(
              builder: (_) {
                final bool loading =
                    _.editOrderStatus == EditOrderStatus.Loading;
                return CustomButton(
                  child: const Text('Сохранить'),
                  onPressed: () => _handleSubmit,
                  loading: loading,
                  height: 56,
                  buttonStyle: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class RowItem extends StatefulWidget {
  const RowItem(this.c, {Key? key}) : super(key: key);
  final dynamic c;
  @override
  _RowItemState createState() => _RowItemState();
}

class _RowItemState extends State<RowItem> {
  int quantity = 0;
  @override
  void initState() {
    quantity = widget.c['quantity_in_fact'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.c['color_name']),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  disabledColor: AppColors.hint,
                  color: AppColors.favorite,
                  onPressed: quantity > 0
                      ? () {
                          setState(() {
                            quantity--;
                          });
                        }
                      : null,
                  icon: const Icon(
                    Icons.remove,
                  ),
                ),
                Text(quantity.toString()),
                IconButton(
                    disabledColor: AppColors.hint,
                    color: AppColors.success,
                    onPressed: quantity >= widget.c['quantity_in_fact']
                        ? null
                        : () {
                            setState(() {
                              quantity++;
                            });
                          },
                    icon: const Icon(Icons.add)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
