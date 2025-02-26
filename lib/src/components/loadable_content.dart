import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadableContent extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;

  const LoadableContent({
    required this.isLoading,
    required this.child,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            enabled: isLoading,
            baseColor: shimmerBaseColor ?? Colors.grey,
            highlightColor: shimmerHighlightColor ?? Colors.white,
            direction: ShimmerDirection.ttb,
            period: Duration(milliseconds: 1200),
            child: child,
          )
        : child;
  }
}
