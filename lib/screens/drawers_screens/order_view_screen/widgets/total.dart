import 'package:flutter/material.dart';

class Total extends StatelessWidget {
  final List items;

  const Total({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
              ),
              children: [
                const TextSpan(
                  text: 'Всего линеек: ',
                ),
                TextSpan(
                  text: '${items.fold(
                    0,
                    (num t, e) => t + e['quantity_in_fact'],
                  )}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
              ),
              children: [
                const TextSpan(
                  text: 'Общая сумма: ',
                ),
                TextSpan(
                  text:
                      '${items.fold(0, (num t, e) => t + double.parse(e['price']) * e['quantity_in_fact'])}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
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
    );
  }
}
