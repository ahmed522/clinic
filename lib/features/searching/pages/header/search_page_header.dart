import 'dart:math';

import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/model/search_option.dart';
import 'package:clinic/features/searching/pages/header/filters_bar/search_page_header_filters_bar_content_widget.dart';
import 'package:clinic/features/searching/pages/header/top_bar/search_page_header_top_bar_content_widget.dart';
import 'package:clinic/features/searching/pages/header/search_bar/search_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class SearchPageHeader extends SliverPersistentHeaderDelegate {
  SearchPageHeader();
  final double _minTopBarHeight = 130;
  final double _maxTopBarHeight = 160;
  final double _shrinkLimit = 0.23;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    var shrinkFactor = min(1, shrinkOffset / (maxExtent - minExtent));
    Widget headerContentWidget = Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 45),
        height:
            max(_maxTopBarHeight * (1 - shrinkFactor * 1.45), _minTopBarHeight),
        decoration: BoxDecoration(
          color: CommonFunctions.isLightMode(context)
              ? AppColors.primaryColor
              : AppColors.darkThemeBottomNavBarColor,
        ),
        child: Column(
          mainAxisAlignment: (shrinkFactor > _shrinkLimit)
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            const SearchPageHeaderTopBarContentWidget(),
            SearchPageHeaderFiltersBarContentWidget(
                topPadding: (shrinkFactor > _shrinkLimit) ? 0 : 5.0),
          ],
        ),
      ),
    );
    return SizedBox(
      height: max(maxExtent - shrinkOffset, minExtent),
      child: Stack(
        fit: StackFit.loose,
        children: [
          if (shrinkFactor <= _shrinkLimit) headerContentWidget,
          const SearchWidget(),
          if (shrinkFactor > _shrinkLimit) headerContentWidget,
        ],
      ),
    );
  }

  @override
  double get maxExtent =>
      (SearchPageController.find.currentOption == SearchOption.clinics)
          ? 220
          : 200;

  @override
  double get minExtent => 130;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
