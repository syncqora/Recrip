import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../others/cache_image.dart';

class AppCarousel extends StatefulWidget {
  final Function(int changedIndex) onCarouselPageChanged;
  final List<String>? images;
  final List<String>? videos;

  const AppCarousel({
    Key? key,
    required this.onCarouselPageChanged,
    required this.images,
    required this.videos,
  }) : super(key: key);

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  // @override
  // void initState() {
  //   super.initState();
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "123",
      child: CarouselSlider.builder(
        // carouselController: controller.newsFeedMediaCarouselControllers[index],
        options: CarouselOptions(
          height: Get.height / 3.5,
          // enlargeCenterPage: false,
          autoPlay: (widget.images!.length + widget.videos!.length) > 1
              ? true
              : false,
          autoPlayInterval: const Duration(seconds: 3),
          initialPage: 0,
          onPageChanged: (carouselIndex, carouselPageChangeReason) {
            widget.onCarouselPageChanged(carouselIndex);
          },
          aspectRatio: 16 / 9,
          enableInfiniteScroll:
              (widget.images!.length + widget.videos!.length) == 1
              ? false
              : true,
          viewportFraction: 1,
        ),
        itemCount: (widget.images!.length + widget.videos!.length),
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            //     Container(
            //   height: 250,
            //   child: Stack(
            //     children: [
            //       Center(
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(4.0),
            //           // child: widget.images!
            //           //         .isNotEmpty
            //           //
            //           //     ?
            //
            //           child: widget.images != null && widget.images!.isNotEmpty
            //               ? widget.images![itemIndex].contains("svg")
            //                   ? SvgPicture.network(
            //                       widget.images![itemIndex],
            //                       fit: BoxFit.contain,
            //                     )
            //                   : (widget.images![itemIndex].contains("png") ||
            //                           widget.images![itemIndex].contains("jpeg") ||
            //                           widget.images![itemIndex].contains("jpg"))
            //                       ? CacheImage(
            //                           url: widget.images![itemIndex],
            //                           fit: BoxFit.contain,
            //                         )
            //                       : widget.videos != null &&
            //                               widget.videos!.isNotEmpty
            //                           ? AlphaVideoPlayer(
            //                               videoUrl: widget.videos![itemIndex],
            //                               loader: Opacity(
            //                                 opacity: 0.3,
            //                                 child: SvgPicture.asset(AppImages.logo),
            //                               ),
            //                             )
            //                           : Center(
            //                               child: SvgPicture.asset(
            //                                 AppImages.logo,
            //                               ),
            //                             )
            //               : widget.videos != null && widget.videos!.isNotEmpty
            //                   ? AlphaVideoPlayer(
            //                       videoUrl: widget.videos![itemIndex],
            //                       loader: Opacity(
            //                         opacity: 0.3,
            //                         child: SvgPicture.asset(AppImages.logo),
            //                       ),
            //                     )
            //                   : Center(
            //                       child: SvgPicture.asset(
            //                         AppImages.logo,
            //                       ),
            //                     ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              height: 250,
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Builder(
                        builder: (context) {
                          if (itemIndex < widget.images!.length) {
                            if (widget.images![itemIndex].contains("svg")) {
                              return SvgPicture.network(
                                widget.images![itemIndex],
                                fit: BoxFit.contain,
                              );
                            } else if (widget.images![itemIndex].contains(
                                  "png",
                                ) ||
                                widget.images![itemIndex].contains("jpeg") ||
                                widget.images![itemIndex].contains("webp") ||
                                widget.images![itemIndex].contains("jpg")) {
                              return CacheImage(
                                url: widget.images![itemIndex],
                                fit: BoxFit.contain,
                              );
                            }
                          }
                          final int videoIndex =
                              itemIndex - widget.images!.length;
                          if (videoIndex >= 0 &&
                              videoIndex < widget.videos!.length) {
                            // return AlphaVideoPlayer(
                            //   videoUrl: widget.videos![videoIndex],
                            //   loader: Opacity(
                            //     opacity: 0.3,
                            //     child: SvgPicture.asset(AppImages.logo),
                            //   ),
                            // );
                          }
                          return Center(
                            child: Image.asset('assets/images/logo.png'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
