import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/model/filter_model.dart';
import 'package:clinic/features/searching/model/filter_type.dart';
import 'package:clinic/features/searching/model/search_option.dart';
import 'package:clinic/features/searching/pages/header/filters_bar/clinic_vezeeta_filter_alert_dialog.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/regions.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'filter_alert_dialog.dart';

class SingleFilterWidget extends StatelessWidget {
  const SingleFilterWidget({
    Key? key,
    required this.filter,
  }) : super(key: key);
  final FilterModel filter;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: filter.active ? null : () => _onFilterPressed(context)(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        margin: const EdgeInsets.only(right: 5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: filter.active ? Colors.white : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (filter.active) ...[
              GestureDetector(
                onTap: () => _onRemoveFilterPressed(),
                child: const Icon(
                  Icons.close,
                  color: AppColors.primaryColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 5),
            ],
            TextButton(
              onPressed: () => _onFilterPressed(context)(),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                filter.content,
                style: TextStyle(
                  color: filter.active ? AppColors.primaryColor : Colors.white,
                  fontSize: 14,
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onRemoveFilterPressed() {
    final controller = SearchPageController.find;
    switch (filter.filterType) {
      case FilterType.doctorSpecializationItem:
      case FilterType.doctorDegreeItem:
      case FilterType.clinicGovernorateItem:
      case FilterType.clinicRegionItem:
        controller.selectFilter(filter, false);
        break;
      case FilterType.clinicVezeeta:
        controller.removeVezeetaFilter();
        break;
      default:
        controller.updateFilterActive(filter, false);
    }
  }

  void Function() _onFilterPressed(BuildContext context) {
    final controller = SearchPageController.find;

    switch (filter.filterType) {
      case FilterType.doctorSpecialization:
      case FilterType.doctorSpecializationItem:
        return () {
          showDialog(
            context: context,
            builder: (context) {
              return FilterAlertDialog(
                title: 'التخصصات',
                items: AppConstants.doctorSpecializations,
                filterType: FilterType.doctorSpecialization,
                filterSearchOption: filter.searchOption,
              );
            },
          );
        };
      case FilterType.doctorDegree:
      case FilterType.doctorDegreeItem:
        return () {
          showDialog(
            context: context,
            builder: (context) {
              return const FilterAlertDialog(
                title: 'الدرجة العلمية',
                items: AppConstants.doctorDegrees,
                filterType: FilterType.doctorDegree,
                filterSearchOption: SearchOption.doctors,
              );
            },
          );
        };
      case FilterType.clinicGovernorate:
      case FilterType.clinicGovernorateItem:
        return () {
          showDialog(
            context: context,
            builder: (context) {
              return const FilterAlertDialog(
                title: 'المحافظات',
                items: Regions.governorates,
                filterType: FilterType.clinicGovernorate,
                filterSearchOption: SearchOption.clinics,
              );
            },
          );
        };
      case FilterType.clinicRegion:
        return () {
          if (controller.filters.any((element) =>
              element.filterType == FilterType.clinicGovernorate)) {
            if (!Get.isSnackbarOpen) {
              MySnackBar.showGetSnackbar(
                  'قم بتحديد المحافظة أولاً', AppColors.primaryColor,
                  isTop: false, duration: const Duration(milliseconds: 800));
            }
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return FilterAlertDialog(
                  title: 'المناطق',
                  items: Regions
                      .governoratesAndRegions[controller.filters
                          .singleWhere((element) =>
                              element.filterType ==
                              FilterType.clinicGovernorateItem)
                          .content]!
                      .keys
                      .toList(),
                  filterType: FilterType.clinicRegion,
                  filterSearchOption: SearchOption.clinics,
                );
              },
            );
          }
        };
      case FilterType.clinicRegionItem:
        return () {
          showDialog(
            context: context,
            builder: (context) {
              return FilterAlertDialog(
                title: 'المناطق',
                items: Regions
                    .governoratesAndRegions[controller.filters
                        .singleWhere((element) =>
                            element.filterType ==
                            FilterType.clinicGovernorateItem)
                        .content]!
                    .keys
                    .toList(),
                filterType: FilterType.clinicRegion,
                filterSearchOption: SearchOption.clinics,
              );
            },
          );
        };
      case FilterType.clinicVezeeta:
        return () {
          showDialog(
            context: context,
            builder: (context) {
              return const ClinicVezeetaFilterAlertDialog();
            },
          );
        };
      default:
        return () {
          if (!filter.active) {
            controller.updateFilterActive(filter, true);
          }
        };
    }
  }
}
