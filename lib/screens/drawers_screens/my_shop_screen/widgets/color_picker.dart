// import 'package:dio/dio.dart' as dio;
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:get/get.dart';
// import 'package:khanbuer_seller_re/helpers/alerts.dart';
// import 'package:khanbuer_seller_re/helpers/api_services.dart';
// import 'package:khanbuer_seller_re/helpers/colors.dart';
// import 'package:khanbuer_seller_re/widgets/custom_button.dart';

// class ColorsTile extends StatefulWidget {
//   final List colors;
//   final List allColors;
//   final Function onChanged;

//   const ColorsTile({
//     Key? key,
//     required this.colors,
//     required this.allColors,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   _ColorsTileState createState() => _ColorsTileState();
// }

// class _ColorsTileState extends State<ColorsTile> {
//   List _colors = [];

//   @override
//   void initState() {
//     _colors = widget.colors;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     dynamic value = 'Выбрать';

//     if (_colors.isNotEmpty) {
//       value = _colors.map((e) => e['name']).join(', ');
//     }

//     return ListTile(
//       tileColor: Colors.white,
//       onTap: () {
//         Get.dialog(
//           ColorsPicker(
//             colors: _colors,
//             allColors: widget.allColors,
//             onChange: (value) {
//               if (mounted) {
//                 setState(() {
//                   _colors = value;
//                 });
//               }
//             },
//             onChanged: (value) => widget.onChanged(value),
//           ),
//         );
//       },
//       title: const Text(
//         'Цвета',
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 14,
//         ),
//       ),
//       subtitle: Padding(
//         padding: const EdgeInsets.only(top: 15),
//         child: Text(
//           value,
//           style: const TextStyle(
//             fontWeight: FontWeight.w300,
//             fontSize: 12,
//           ),
//         ),
//       ),
//       trailing: const Icon(
//         Icons.keyboard_arrow_right,
//         color: Colors.black,
//         size: 20,
//       ),
//     );
//   }
// }

// class ColorsPicker extends StatefulWidget {
//   final List colors;
//   final List allColors;
//   final Function onChange;
//   final Function onChanged;

//   const ColorsPicker({
//     Key? key,
//     required this.colors,
//     required this.allColors,
//     required this.onChange,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   _ColorsPickerState createState() => _ColorsPickerState();
// }

// class _ColorsPickerState extends State<ColorsPicker> {
//   List _colors = [];
//   bool _loading = false;
//   final TextEditingController _colorsController = TextEditingController();

//   @override
//   void initState() {
//     _colors = widget.colors;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _colorsController.dispose();
//     widget.onChanged(_colors);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Цвета'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 8,
//           vertical: 10,
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 18,
//               ),
//               color: Colors.white,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Цвет',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   TypeAheadFormField(
//                     noItemsFoundBuilder: (_) => const SizedBox(),
//                     textFieldConfiguration: TextFieldConfiguration(
//                       style: const TextStyle(fontSize: 14),
//                       textInputAction: TextInputAction.done,
//                       keyboardType: TextInputType.text,
//                       controller: _colorsController,
//                       decoration: InputDecoration(
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.hint),
//                         ),
//                         hintText: 'Выберите или введите свой цвет',
//                         hintStyle: const TextStyle(
//                           fontSize: 12,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                     suggestionsCallback: (pattern) {
//                       List matches = [];
//                       matches.addAll(widget.allColors);
//                       matches.retainWhere((s) => s['name']
//                           .toLowerCase()
//                           .contains(pattern.toLowerCase()));
//                       return matches;
//                     },
//                     itemBuilder: (_, dynamic suggestion) => ListTile(
//                       title: Text(
//                         suggestion['name'],
//                         style: const TextStyle(
//                           fontSize: 14,
//                         ),
//                       ),
//                       selected: true,
//                       dense: true,
//                     ),
//                     transitionBuilder: (_, suggestionsBox, ac) =>
//                         suggestionsBox,
//                     onSuggestionSelected: (dynamic suggestion) {
//                       _colorsController.text = suggestion['name'];
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             CustomButton(
//               loading: _loading,
//               onPressed: () async {
//                 bool isAdded = _colors.any(
//                     (element) => element['name'] == _colorsController.text);
//                 bool isNew = widget.allColors.every(
//                     (element) => element['name'] != _colorsController.text);
//                 if (isNew) {
//                   try {
//                     setState(() {
//                       _loading = true;
//                     });
//                     final Map<String, dynamic> params = {
//                       'code': '#ffffff',
//                       'name': _colorsController.text,
//                     };
//                     dio.Response response = await addColorApi(params);
//                     if (response.data['success']) {
//                       setState(() {
//                         _colors.add(response.data['color']);
//                       });
//                       _colorsController.clear();
//                       widget.allColors.add(response.data['color']);
//                       widget.onChange(_colors);
//                     }
//                   } on dio.DioError catch (error) {
//                     errorAlert(error.response!.data);
//                   } finally {
//                     setState(() {
//                       _loading = false;
//                     });
//                   }
//                 } else if (!isAdded) {
//                   Map color = widget.allColors.firstWhere(
//                       (element) => element['name'] == _colorsController.text);
//                   setState(() {
//                     _colors.add(color);
//                   });
//                   _colorsController.clear();
//                   widget.onChange(_colors);
//                 } else {
//                   _colorsController.clear();
//                 }
//               },
//               height: 56,
//               width: double.infinity,
//               buttonStyle: ButtonStyle(
//                 shape: MaterialStateProperty.all(
//                   const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.zero,
//                   ),
//                 ),
//               ),
//               child: const Text(
//                 'ДОБАВИТЬ',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 2,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 34),
//             ..._colors
//                 .map(
//                   (color) => Container(
//                     height: 56,
//                     padding: const EdgeInsets.only(
//                       left: 16,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border(
//                         bottom: BorderSide(
//                           color: AppColors.border,
//                           width: 1,
//                         ),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             '${color['name']}',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child: Material(
//                             borderRadius: BorderRadius.circular(50),
//                             color: Colors.white,
//                             child: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _colors.removeWhere((element) =>
//                                       element['name'] == color['name']);
//                                 });
//                               },
//                               icon: const Icon(
//                                 Icons.circle,
//                                 color: Colors.red,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
