import 'package:clinic/global/widgets/error_page.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';

class OfflinePageBuilder extends StatelessWidget {
  const OfflinePageBuilder({
    super.key,
    required this.child,
    this.offlineWidget = const ErrorPage(
        imageAsset: 'assets/img/internet-error.svg',
        message: 'حدثت مشكلة حاول الإتصال بالإنترنت وإعادة المحاولة'),
  });
  final Widget child;
  final Widget offlineWidget;
  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      child: offlineWidget,
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget offlineWidget,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        if (connected) {
          return child;
        } else {
          return offlineWidget;
        }
      },
    );
  }
}
