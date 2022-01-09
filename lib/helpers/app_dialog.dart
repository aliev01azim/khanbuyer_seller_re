import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/products_controller.dart';
import '../widgets/custom_button.dart';
import 'colors.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Function onConfirm;
  final Function onCancel;

  const AppDialog({
    Key? key,
    required this.title,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 24,
      contentPadding: const EdgeInsets.only(
        top: 45,
        left: 30,
        right: 30,
        bottom: 30,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: GetBuilder<ProductsController>(
                  builder: (_) {
                    final bool loading = _.status == AddProductStatus.Loading;
                    return CustomButtonForDialog(
                      onPressed: onConfirm,
                      loading: loading,
                      child: const FittedBox(
                        child: Text(
                          'Да',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      buttonStyle: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: CustomButtonForDialog(
                  onPressed: onCancel,
                  child: const FittedBox(
                    child: Text(
                      'Нет',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  buttonStyle: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      AppColors.disabled,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }
}
