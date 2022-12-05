import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Allows for automatic CORS offloading
abstract class PlatformImageProxy {
  FutureOr<Uri> prepareUri(Object uri);
}

bool useCachedNetworkImage = false;

typedef ImageProviderFactory<T extends Object> = ImageProvider<T>
    Function(dynamic, {Map<String, String>? headers});

ImageProvider PlatformNetworkImageProvider(dynamic url,
    {Map<String, String>? headers}) {
  return ((kIsWeb || !useCachedNetworkImage
          ? NetworkImage("$url", headers: headers)
          : CachedNetworkImageProvider("$url")) as ImageProvider<dynamic>)
      as ImageProvider<Object>;
}

/// Wraps an image factory and uses the proxy to alter the URI of the requested
/// image
ImageProviderFactory ProxyImageProviderFactory(
    PlatformImageProxy Function() proxy,
    [ImageProviderFactory factory = PlatformNetworkImageProvider]) {
  return (image, {Map<String, String>? headers}) {
    return ProxyNetworkImage(
        proxy: proxy(),
        factory: factory,
        originalUrl: image as Object,
        headers: headers);
  };
}

class ProxyNetworkImage extends ImageProvider {
  final PlatformImageProxy proxy;
  final ImageProviderFactory factory;
  ImageProvider? delegate;
  final Object originalUrl;
  Uri? destinationUrl;
  final Map<String, String>? headers;

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) async {
    if (destinationUrl == null) {
      destinationUrl = await proxy.prepareUri(this.originalUrl);
    }

    delegate = factory(destinationUrl, headers: headers);

    return delegate!.obtainKey(configuration);
  }

  @override
  ImageStreamCompleter load(Object key, DecoderCallback decode) {
    return delegate!.load(key, decode);
  }

  ProxyNetworkImage({
    required this.proxy,
    required this.factory,
    required this.originalUrl,
    this.headers,
  });
}
