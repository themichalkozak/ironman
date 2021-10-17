import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ironman/features/event/framework/presentation/widgets/sliver_app_bar_delegate.dart';

class SliverSubHeader extends StatelessWidget {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final bool pinned;

  const SliverSubHeader(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child,
      this.pinned = false});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: pinned,
        delegate: SliverAppBarDelegate(
            minHeight: minHeight, maxHeight: maxHeight, child: child));
  }
}
