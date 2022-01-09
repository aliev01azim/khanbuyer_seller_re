import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../helpers/api_services.dart';

typedef DoubleClickAnimationListener = void Function();

class ViewPictureDetail extends StatefulWidget {
  final dynamic imageList;
  final int imageId;

  const ViewPictureDetail({Key? key, this.imageList, required this.imageId})
      : super(key: key);

  @override
  _ViewPictureDetailState createState() => _ViewPictureDetailState();
}

class _ViewPictureDetailState extends State<ViewPictureDetail>
    with TickerProviderStateMixin {
  late ExtendedPageController controller;

  late AnimationController _doubleClickAnimationController;
  late AnimationController _slideEndAnimationController;

  late Animation<double> _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];
  late int currentIndex;

  @override
  void initState() {
    currentIndex = widget.imageId;
    int defaultPageIndex =
        widget.imageList.indexWhere((item) => item['id'] == currentIndex);
    _slideEndAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    controller = ExtendedPageController(initialPage: defaultPageIndex);

    _slideEndAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _doubleClickAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _doubleClickAnimationController.dispose();
    _slideEndAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('icount $icount');
    return Stack(
      children: [
        buildPhotoViewGallery(context),
        _buildIndicator(),
        _buildBackButton(),
      ],
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.imageList.map<Widget>((item) {
          return buildDot(item['id']);
        }).toList(),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 40.0,
      left: 20.0,
      child: GestureDetector(
          // color: Colors.blue,
          child: const Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
          onTap: () {
            Get.back();
          }),
    );
  }

  Container buildDot(imageId) {
    return Container(
      // child: ,
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 3),
      //color: Colors.red,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == imageId ? Colors.red : Colors.grey[700],
      ),
    );
  }

  ExtendedImageGesturePageView buildPhotoViewGallery(context) {
    return ExtendedImageGesturePageView.builder(
      itemCount: widget.imageList.length,
      itemBuilder: (BuildContext context, index) {
        var item = widget.imageList[index];
        Widget image = ExtendedImage.network(
          Config.baseUrl + item['picture'],
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          enableSlideOutPage: true,
          onDoubleTap: (ExtendedImageGestureState state) {
            ///you can use define pointerDownPosition as you can,
            ///default value is double tap pointer down postion.
            final Offset? pointerDownPosition = state.pointerDownPosition;
            final double? begin = state.gestureDetails?.totalScale;
            double end;

            //remove old
            _doubleClickAnimation.removeListener(_doubleClickAnimationListener);

            //stop pre
            _doubleClickAnimationController.stop();

            //reset to use
            _doubleClickAnimationController.reset();

            if (begin == doubleTapScales[0]) {
              end = doubleTapScales[1];
            } else {
              end = doubleTapScales[0];
            }

            _doubleClickAnimationListener = () {
              //print(_animation.value);
              state.handleDoubleTap(
                  scale: _doubleClickAnimation.value,
                  doubleTapPosition: pointerDownPosition);
            };
            _doubleClickAnimation = _doubleClickAnimationController
                .drive(Tween<double>(begin: begin, end: end));

            _doubleClickAnimation.addListener(_doubleClickAnimationListener);

            _doubleClickAnimationController.forward();
          },
          initGestureConfigHandler: (state) => GestureConfig(
            inPageView: true,
            speed: 1.0,
            initialScale: 1.0,
            minScale: 0.9,
            maxScale: 2,

            //you can cache gesture state even though page view page change.
            //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
            cacheGesture: false,
          ),
        );
        image = Container(
          color: const Color(0xFFE8E9E4),
          child: image,
          padding: const EdgeInsets.all(5.0),
        );
        return image;
      },
      // enableRotation: true,
      controller: controller,
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) {
        if (widget.imageList[index]['id'] != null) {
          setState(() {
            currentIndex = widget.imageList[index]['id'];
          });
        }
      },
    );
  }
// return PhotoViewGalleryPageOptions(
//   imageProvider: NetworkImage(widget.imageList[index]),
//   minScale: PhotoViewComputedScale.contained * 0.9,
//   maxScale: PhotoViewComputedScale.covered * 2,
// );

// scrollPhysics: BouncingScrollPhysics(),
// backgroundDecoration: BoxDecoration(
//   color: Theme.of(context).canvasColor,
// ),
// loadingBuilder: (context, ImageChunkEvent event) {
//   return Center(
//     child: CircularProgressIndicator(),
//   );
// }

// return PhotoViewGallery.builder(
//     scrollPhysics: BouncingScrollPhysics(),
//     itemCount: widget.imageList.length,
//     builder: (context, int index) {
//       return PhotoViewGalleryPageOptions(
//         imageProvider: NetworkImage(widget.imageList[index]),
//         minScale: PhotoViewComputedScale.contained * 0.9,
//         maxScale: PhotoViewComputedScale.covered * 2,
//       );
//     },
//     // enableRotation: true,
//     scrollDirection: Axis.horizontal,
//     pageController: controller,
//     onPageChanged: (index) {
//       setState(() {
//         currentIndex = index;
//       });
//     },
//     backgroundDecoration: BoxDecoration(
//       color: Theme.of(context).canvasColor,
//     ),
//     loadingBuilder: (context, ImageChunkEvent event) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     });

//   return PhotoViewGallery(
//     pageOptions:
//  widget.imageList
//         .map<PhotoViewGalleryPageOptions>(
//             (imagePath) => PhotoViewGalleryPageOptions(
//                   imageProvider: NetworkImage(imagePath),
//                   minScale: PhotoViewComputedScale.contained * 0.9,
//                   maxScale: PhotoViewComputedScale.covered * 2,
//                 ))
//         .toList(),
//   );
}
