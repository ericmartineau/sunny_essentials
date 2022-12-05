import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:sunny_essentials/image/platform_image_proxy.dart';
import 'package:sunny_platform_widgets/sunny_platform_widgets.dart';

export 'platform_image_proxy.dart';

typedef ImageProgressBuilder = Widget Function(
    BuildContext context, DownloadProgress progress);

class PlatformNetworkImage extends PlatformWidgetBase {
  static ImageProviderFactory imageProviderFactory =
      PlatformNetworkImageProvider;

  final String? imageUrl;
  final double? height;
  final double? width;
  final Widget Function(BuildContext context, String url)? placeholder;
  final ImageProgressBuilder? progressBuilder;

  final Map<String, String>? httpHeaders;
  final Widget Function(BuildContext context, String url, Object? err)
      errorWidget;
  final Alignment alignment;
  final bool useOldImageOnUrlChange;
  final BoxFit? fit;
  final ImageProviderFactory? factory;

  static ImageProvider provider(imageUrl, {Map<String, String>? headers}) =>
      imageProviderFactory(imageUrl, headers: headers);

  PlatformNetworkImage(dynamic imageUrl,
      {Key? key,
      this.height,
      this.width,
      this.httpHeaders,
      this.factory,
      this.placeholder,
      bool showProgress = true,
      ImageProgressBuilder? progressBuilder,
      this.errorWidget = _defaultErrorWidget,
      this.alignment = Alignment.center,
      this.useOldImageOnUrlChange = false,
      this.fit,
      extraOptions})
      : progressBuilder = (showProgress ? _defaultProgressBuilder : null),
        assert(imageUrl != null),
        imageUrl = "$imageUrl",
        super(key: key, extraOptions: extraOptions);

  @override
  Widget createMaterialWidget(BuildContext context) => createNative();

  @override
  Widget createCupertinoWidget(BuildContext context) => createNative();

  Widget createNative() {
    return imageUrl == null
        ? Container(
            height: height,
            width: width,
            color: Colors.grey.withOpacity(0.5),
          )
        : OctoImage(
            image: (factory ?? imageProviderFactory)(imageUrl!,
                headers: httpHeaders),
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            placeholderBuilder:
                placeholder == null ? null : _octoPlaceholderBuilder,
            progressIndicatorBuilder: placeholder != null
                ? null
                : progressBuilder == null
                    ? null
                    : _octoProgressIndicatorBuilder,
            errorBuilder: _octoErrorBuilder,
          );
  }

  Widget _octoPlaceholderBuilder(BuildContext context) {
    return placeholder!(context, imageUrl!);
  }

  Widget _octoProgressIndicatorBuilder(
    BuildContext context,
    ImageChunkEvent? progress,
  ) {
    int? totalSize;
    var downloaded = 0;
    if (progress != null) {
      totalSize = progress.expectedTotalBytes;
      downloaded = progress.cumulativeBytesLoaded;
    }
    return progressBuilder!(
        context,
        DownloadProgress(
          imageUrl!,
          totalSize,
          downloaded,
        ));
  }

  Widget _octoErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return errorWidget(context, imageUrl!, error);
  }
}

Widget _defaultErrorWidget(BuildContext context, String url, dynamic error) {
  return Icon(Icons.error);
}

Widget _defaultProgressBuilder(
    BuildContext context, DownloadProgress progress) {
  return SizedBox(
    height: 65,
    child: AspectRatio(
        aspectRatio: 1.0,
        child: progress.progress == null
            ? CircularProgressIndicator()
            : CircularProgressIndicator(value: progress.progress!)),
  );
}
