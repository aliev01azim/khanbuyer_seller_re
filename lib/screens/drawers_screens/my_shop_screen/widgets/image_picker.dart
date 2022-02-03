import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';
import 'package:khanbuer_seller_re/helpers/colors.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../../../../widgets/custom_image.dart';

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
      height: widget.images.isEmpty ? 125 : 260,
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

class EditingImagePicker extends StatelessWidget {
  final List images;
  final List networkImages;
  final Function loadAssets;
  final Function localRemove;
  final Function localRemoveForNetImages;
  final dynamic colorId;
  final dynamic productId;

  EditingImagePicker({
    Key? key,
    required this.images,
    required this.networkImages,
    required this.localRemoveForNetImages,
    required this.loadAssets,
    required this.localRemove,
    required this.colorId,
    required this.productId,
  }) : super(key: key);
  final _controller = Get.find<ProductsController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 165,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          networkImages.isNotEmpty || images.isNotEmpty
              ? Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...networkImages
                              .map(
                                (image) => Container(
                                  margin:
                                      networkImages[networkImages.length - 1] ==
                                              image
                                          ? null
                                          : const EdgeInsets.only(right: 10),
                                  child: SizedBox(
                                    height: 165,
                                    width: 125,
                                    child: Stack(
                                      children: [
                                        CustomImage(
                                          url: image['thumbnailPicture'],
                                          height: 165,
                                          width: 125,
                                        ),
                                        GetBuilder<ProductsController>(
                                          builder: (_) {
                                            return Positioned(
                                              top: 2,
                                              right: 2,
                                              child: _.removingImageLoading &&
                                                      _.imageId == image['id']
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      width: 25,
                                                      height: 25,
                                                      child:
                                                          const CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        final val =
                                                            await _controller
                                                                .removeColorImage(
                                                          image['id'],
                                                          productId,
                                                          colorId,
                                                        );
                                                        if (val) {
                                                          localRemoveForNetImages(
                                                              image);
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              width: 1),
                                                        ),
                                                        child: const Icon(
                                                          Icons.close,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          ...images
                              .map(
                                (image) => Container(
                                  margin: images[images.length - 1] == image
                                      ? null
                                      : const EdgeInsets.only(
                                          left: 10, right: 10),
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
                                          onTap: () => localRemove(image),
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(width: 1),
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
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
                height: 97,
                width: 97,
                child: IconButton(
                  splashRadius: 48,
                  onPressed: () => loadAssets(),
                  icon: const Icon(Icons.add_a_photo),
                  color: AppColors.icon,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
