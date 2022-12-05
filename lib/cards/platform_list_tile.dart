import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_degen_annotations/flutter_degen_annotations.dart';
import 'platform_card_theme.dart';
import '../container/auto_layout.dart';

import 'platform_card.dart';

part 'platform_list_tile.g.dart';

@degen()
abstract class _PlatformListTile extends StatelessWidget
    with _PlatformCardArgsMixin {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? bottom;

  @delegate(implementDelegate: true)
  final PlatformCardArgs? _args;

  const _PlatformListTile(
    @flatten() this._args, {
    Key? key,
    this.leading,
    this.title,
    this.bottom,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  const _PlatformListTile.cardArgs(
    this._args, {
    Key? key,
    this.leading,
    this.title,
    this.bottom,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  _PlatformListTile.nocard({
    Key? key,
    this.leading,
    this.title,
    this.bottom,
    FutureOr<dynamic> Function(BuildContext)? onTap,
    this.subtitle,
    this.trailing,
  })  : _args = PlatformCardArgs(
          useShadow: false,
          onTap: onTap,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      contentPadding: padding == null ? padding : padding! * 4,
      onTap: onTap == null ? null : () => this.onTap?.call(context),
      onLongPress:
          onLongPress == null ? null : () => this.onLongPress?.call(context),
      title: title,
      leading: leading,
      trailing: trailing,
      subtitle: subtitle,
      tileColor: color,
    );
    return PlatformCard(
      args: this.copyWith(
        args: this._args?.copyArgs(padding: EdgeInsets.zero),
      ),
      child: bottom == null
          ? tile
          : Layout.column().noFlex.crossAxisStretch.build(
                tile,
                bottom,
              ),
    );
  }

  PlatformListTile copyWith({
    Widget? leading,
    Widget? title,
    Widget? bottom,
    Widget? subtitle,
    Widget? trailing,
    PlatformCardArgs? args,
  }) {
    return PlatformListTile.cardArgs(
      args,
      leading: leading ?? this.leading,
      title: title ?? this.title,
      bottom: bottom ?? this.bottom,
      subtitle: subtitle ?? this.subtitle,
      trailing: trailing ?? this.trailing,
    );
  }
}
