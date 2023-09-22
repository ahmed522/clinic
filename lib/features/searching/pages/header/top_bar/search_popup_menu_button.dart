import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/model/search_option.dart';
import 'package:clinic/features/searching/pages/header/top_bar/current_search_option_widget.dart';
import 'package:clinic/features/searching/pages/header/top_bar/search_option_item.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class SearchPopupMenuButton extends StatelessWidget {
  const SearchPopupMenuButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchPageController controller = SearchPageController.find;
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 0:
            controller.updateCurrentOption(SearchOption.doctors);
            break;
          case 1:
            controller.updateCurrentOption(SearchOption.clinics);
            break;
          case 2:
            controller.updateCurrentOption(SearchOption.users);
            break;
          case 3:
            controller.updateCurrentOption(SearchOption.posts);
            break;
        }
      },
      position: PopupMenuPosition.under,
      elevation: 5.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(5),
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(15),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          textStyle: _getPopupItemTextStyle(context),
          child: const SearchOptionItem(option: SearchOption.doctors),
        ),
        PopupMenuItem(
          value: 1,
          textStyle: _getPopupItemTextStyle(context),
          child: const SearchOptionItem(option: SearchOption.clinics),
        ),
        PopupMenuItem(
          value: 2,
          textStyle: _getPopupItemTextStyle(context),
          child: const SearchOptionItem(option: SearchOption.users),
        ),
        PopupMenuItem(
          value: 3,
          textStyle: _getPopupItemTextStyle(context),
          child: const SearchOptionItem(option: SearchOption.posts),
        ),
      ],
      child: const CurrentSearchOptionWidget(),
    );
  }

  TextStyle _getPopupItemTextStyle(BuildContext context) => TextStyle(
        fontFamily: AppFonts.mainArabicFontFamily,
        color:
            CommonFunctions.isLightMode(context) ? Colors.black : Colors.white,
      );
}
