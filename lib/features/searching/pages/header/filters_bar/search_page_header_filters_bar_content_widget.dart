import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/pages/header/filters_bar/single_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPageHeaderFiltersBarContentWidget extends StatelessWidget {
  const SearchPageHeaderFiltersBarContentWidget({
    Key? key,
    required this.topPadding,
  }) : super(key: key);
  final double topPadding;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GetBuilder<SearchPageController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.only(bottom: 2.0, top: topPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 25.0,
                maxHeight: 25.0,
              ),
              child: Center(
                child: ListView.builder(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.filters.length,
                  itemBuilder: (context, index) => SingleFilterWidget(
                    filter: controller.filters.reversed.toList()[index],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
