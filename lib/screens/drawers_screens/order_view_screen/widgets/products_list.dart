import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/orders_controller.dart';
import '../../../../helpers/colors.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_image.dart';
import 'edit_item_screen.dart';

class ProductsList extends StatelessWidget {
  final List products;

  const ProductsList({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List _new = [];
    final List _inProcess = [];
    final List _readyToSend = [];
    final List _completed = [];
    for (var prod in products) {
      prod['grouped'].values.forEach((element) {
        final bool isCompleted = element.every((e) => e['status'] == 3);
        final bool isReadyToSend = element.every((e) => e['status'] == 2);
        final bool isInProcess = element.every((e) => e['status'] == 1);
        final bool isNew = element.every((e) => e['status'] == 0);
        if (isNew) {
          _new.add(element);
        }
        if (isInProcess) {
          _inProcess.add(element);
        }
        if (isReadyToSend) {
          _readyToSend.add(element);
        }
        if (isCompleted) {
          _completed.add(element);
        }
      });
    }

    return Column(children: [
      _completed.isNotEmpty
          ? ProductsListByStatus(
              productItems: _completed,
              statusName: 'Отправлены',
            )
          : const SizedBox(),
      _readyToSend.isNotEmpty
          ? ProductsListByStatus(
              productItems: _readyToSend,
              statusName: 'Готовые к отправке',
            )
          : const SizedBox(),
      _inProcess.isNotEmpty
          ? ProductsListByStatus(
              productItems: _inProcess,
              statusName: 'В процессе',
            )
          : const SizedBox(),
      _new.isNotEmpty
          ? ProductsListByStatus(
              productItems: _new,
              statusName: 'Новые',
            )
          : const SizedBox(),
    ]);
  }
}

class ProductsListByStatus extends StatelessWidget {
  final List productItems;
  final String statusName;

  const ProductsListByStatus({
    Key? key,
    required this.productItems,
    required this.statusName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        statusName.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 20,
                ),
                child: Text(
                  statusName,
                  style: const TextStyle(fontSize: 12),
                ),
              )
            : const SizedBox(),
        ...productItems.map(
          (item) {
            if (item[0]['product'] == null) {
              return const SizedBox();
            }
            int summa = 0;
            item.forEach((co) {
              summa = summa +
                  (co['quantity_in_fact'] * double.parse(co['price']).ceil()
                      as int);
            });
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(238, 238, 238, 1),
                    spreadRadius: -1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomImage(
                      url: item[0]['product']['colors'][0]['thumbnailPicture'],
                      height: 160,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item[0]['product']['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                iconSize: 24,
                                onPressed: () {
                                  Get.dialog(
                                    EditItemScreen(item: item),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              )
                            ],
                          ),
                          Text(
                            'Артикул: ${item[0]['product']['colors'][0]['item_code']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...item
                              .map(
                                (c) => Container(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          c['color_name'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${c['quantity_in_fact']}',
                                                style: c['quantity_in_fact'] <
                                                        c['quantity']
                                                    ? TextStyle(
                                                        color:
                                                            AppColors.favorite,
                                                      )
                                                    : null,
                                              ),
                                              TextSpan(
                                                text:
                                                    '/${c['quantity']}   x   ${double.parse(c['price']).ceil()} сом',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Сумма: $summa сом',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ).toList(),
      ],
    );
  }
}
