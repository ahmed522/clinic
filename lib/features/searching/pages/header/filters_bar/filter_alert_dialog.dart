import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/model/filter_model.dart';
import 'package:clinic/features/searching/model/filter_type.dart';
import 'package:clinic/features/searching/model/search_option.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterAlertDialog extends StatelessWidget {
  const FilterAlertDialog({
    Key? key,
    required this.filterType,
    required this.title,
    required this.items,
    required this.filterSearchOption,
  }) : super(key: key);

  final SearchOption filterSearchOption;
  final FilterType filterType;
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      scrollable: true,
      title: Text(
        title,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.darkThemeBackgroundColor
              : Colors.white,
        ),
      ),
      content: Column(
        children: List<Row>.generate(
          items.length,
          (index) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<SearchPageController>(
                builder: (controller) {
                  return Checkbox(
                    value: controller.selectedFilters.contains(items[index]),
                    onChanged: (value) {
                      FilterModel selectedFilter = FilterModel(
                        searchOption: filterSearchOption,
                        filterType: _itemFilterType,
                      );
                      selectedFilter.content = items[index];
                      controller.selectFilter(selectedFilter, value!);
                    },
                    activeColor: AppColors.primaryColor,
                  );
                },
              ),
              Text(
                items[index],
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: (CommonFunctions.isLightMode(context))
                      ? AppColors.darkThemeBackgroundColor
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.start,
      actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
      actions:
          MyAlertDialog.getAlertDialogActions({'العودة': () => Get.back()}),
    );
  }

  FilterType get _itemFilterType {
    switch (filterType) {
      case FilterType.doctorSpecialization:
        return FilterType.doctorSpecializationItem;
      case FilterType.doctorDegree:
        return FilterType.doctorDegreeItem;
      case FilterType.clinicGovernorate:
        return FilterType.clinicGovernorateItem;
      case FilterType.clinicRegion:
        return FilterType.clinicRegionItem;
      default:
        return FilterType.doctorSpecializationItem;
    }
  }
}
