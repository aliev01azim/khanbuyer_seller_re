import 'package:flutter/material.dart';
import 'package:khanbuer_seller_re/helpers/colors.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ImagePicker extends StatefulWidget {
  final List images;
  final Function loadAssets;

  const ImagePicker({
    Key? key,
    required this.images,
    required this.loadAssets,
  }) : super(key: key);

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: widget.images.isEmpty ? 105 : 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.images.isNotEmpty
              ? Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.images
                            .map(
                              (image) => Container(
                                margin:
                                    widget.images[widget.images.length - 1] ==
                                            image
                                        ? null
                                        : const EdgeInsets.only(right: 10),
                                child: Stack(
                                  children: [
                                    AssetThumb(
                                      asset: image,
                                      height: 165,
                                      width: 125,
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            widget.images.removeWhere(
                                                (element) => element == image);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(width: 2),
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Material(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(50),
              child: SizedBox(
                height: widget.images.isEmpty ? 97 : 40,
                width: widget.images.isEmpty ? 97 : 40,
                child: IconButton(
                  splashRadius: 48,
                  onPressed: () => widget.loadAssets(),
                  icon: Icon(
                      widget.images.isEmpty ? Icons.add_a_photo : Icons.add),
                  // color: AppColors.icon,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
