import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/helpers/colors.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';

import '../../../../controllers/orders_controller.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({Key? key, this.item}) : super(key: key);
  final dynamic item;
  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменить '),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: ListView.builder(
          itemCount: widget.item.length,
          itemBuilder: (_, index) => RowItem(
            widget.item,
            widget.item[index],
          ),
        ),
      ),
    );
  }
}

class RowItem extends StatefulWidget {
  const RowItem(this.o, this.c, {Key? key}) : super(key: key);
  final dynamic o;
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(widget.c['color_name']),
              flex: 5,
            ),
            Expanded(
              flex: 3,
              child: Row(
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
                    onPressed: quantity < widget.c['quantity']
                        ? () {
                            setState(() {
                              quantity++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: GetBuilder<OrdersController>(
                builder: (_) {
                  // final orderIndex =
                  //     _.orderDetails['grouped'].values.toList().indexOf(widget.o);
                  // final coloIndex = widget.o.indexOf(widget.c);
                  // final color = _.orderDetails['grouped'].values
                  //     .toList()[orderIndex][coloIndex];
                  final bool loading =
                      _.editItemStatus == EditItemStatus.Loading
                      // &&
                      //     color['id'] == widget.c['id']
                      ;
                  return IconButton(
                    onPressed: quantity != widget.c['quantity_in_fact']
                        ? () async => _.editOrderItem(
                            widget.c['id'], quantity, widget.c['product_id'])
                        : null,
                    icon: loading
                        ? const IndicatorMini(color: Colors.blue)
                        : const Icon(Icons.done),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
