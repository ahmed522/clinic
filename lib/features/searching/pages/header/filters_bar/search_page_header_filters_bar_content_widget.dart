import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/pages/header/filters_bar/single_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPageHeaderFiltersBarContentWidget extends StatelessWidget {
  const SearchPageHeaderFiltersBarContentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GetBuilder<SearchPageController>(
        builder: (controller) {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 20.0,
              maxHeight: 30.0,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.only(right: 10, left: 10, top: 8.0),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.filters.length,
              itemBuilder: (context, index) => SingleFilterWidget(
                filter: controller.filters.reversed.toList()[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
