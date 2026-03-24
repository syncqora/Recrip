import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../constants/app.dart';

class CacheImage extends StatelessWidget {
  static final customCacheManager = CacheManager(
    Config(AppConstants.appCacheKey, stalePeriod: const Duration(days: 7)),
  );

  final String? url;
  final BoxFit? fit;

  CacheImage({Key? key, required this.url, this.fit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      // Provide a fallback for empty or null URLs
      return _buildPlaceholder();
    }

    if (url!.startsWith('http')) {
      // Use CachedNetworkImage for network URLs
      return CachedNetworkImage(
        cacheManager: customCacheManager,
        imageUrl: url!,
        fit: fit ?? BoxFit.cover,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Opacity(
          opacity: 0.3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        errorWidget: (context, url, error) => Opacity(
          opacity: 0.3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      );
    } else {
      // Use local assets if the URL is not an HTTP link
      return _buildPlaceholder();
    }
  }

  // A method to return the fallback widget
  Widget _buildPlaceholder() {
    return Opacity(
      opacity: 0.3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
