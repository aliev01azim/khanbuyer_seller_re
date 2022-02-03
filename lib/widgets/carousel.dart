import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';
import '../screens/drawers_screens/my_shop_screen/add_product_screen/widgets/view_picture_detail.dart';
import 'app_indicator.dart';
import 'custom_image.dart';

class Carousel extends StatefulWidget {
  final dynamic product;
  final dynamic color;
  final Function setstate;
  const Carousel({
    Key? key,
    required this.product,
    required this.color,
    required this.setstate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CarouselState();
  }
}

class _CarouselState extends State<Carousel> {
  int _current = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    _current = widget.color['pictures'][0]['id'] ?? 0;

    super.initState();
  }

  List<Widget> _buildCarouselSliders() {
    List<Widget> _carouselSliders = [];

    for (var item in widget.color['pictures']) {
      bool isMain = item['isMain'] == 1;
      _carouselSliders.add(
        Stack(
          children: [
            CustomImage(
              url: item['picture'],
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            if (item['isMain'] != null || item['id'] != null)
              Container(
                alignment: Alignment.bottomCenter,
                child: Material(
                  color: Colors.transparent,
                  child: GetBuilder<ProductsController>(
                    builder: (_) {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(137, 0, 119, 255)),
                        ),
                        child: Text(
                          isMain ? 'Главное фото' : 'Сделать главным',
                        ),
                        onPressed: _.settingImageLoading || isMain
                            ? null
                            : () async {
                                final value = await _.setImageAsMain(
                                    item['id'], widget.product, widget.color);
                                if (value) {
                                  await _carouselController.animateToPage(0);
                                  widget.setstate();
                                }
                              },
                      );
                    },
                  ),
                ),
              ),
            if (item['isMain'] != null || item['id'] != null)
              GetBuilder<ProductsController>(
                builder: (_) {
                  return Positioned(
                    top: 10,
                    right: 20,
                    child: _.removingImageLoading && _.imageId == item['id']
                        ? Container(
                            padding: const EdgeInsets.all(3),
                            width: 25,
                            height: 25,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              final value = await _.removeColorImage(
                                item['id'],
                                widget.product['id'],
                                widget.color['id'],
                              );
                              if (value) {
                                await _carouselController.nextPage();
                              }
                              widget.setstate();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 1),
                                  color: Colors.red),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                              ),
                            ),
                          ),
                  );
                },
              ),
            GetBuilder<ProductsController>(builder: (_) {
              return _.settingImageLoading
                  ? const AppIndicator()
                  : const SizedBox();
            }),
          ],
        ),
      );
    }

    return _carouselSliders;
  }

  List<Widget> _buildCarouselIndicators() {
    List<Widget> _carouselIndicators = [];
    for (var item in widget.color['pictures']) {
      _carouselIndicators.add(
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 4,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _current == item['id']
                ? const Color(0xFFC4C4C4)
                : const Color(0xFFEBF0FF),
          ),
        ),
      );
    }
    return _carouselIndicators;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewPictureDetail(
                  imageList: widget.color['pictures'],
                  imageId: _current,
                ),
              ),
            );
          },
          child: CarouselSlider(
            carouselController: _carouselController,
            items: _buildCarouselSliders(),
            options: CarouselOptions(
              aspectRatio: 1.2,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                if (widget.color['pictures'][index]['id'] != null) {
                  setState(() {
                    _current = widget.color['pictures'][index]['id'];
                  });
                }
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildCarouselIndicators(),
        ),
      ],
    );
  }
}
