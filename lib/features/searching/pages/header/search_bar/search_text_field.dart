import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/model/search_option.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/card_text_field.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key? key,
    required this.currentOption,
  }) : super(key: key);
  final SearchOption currentOption;
  @override
  Widget build(BuildContext context) {
    final controller = SearchPageController.find;
    return CardTextField(
      controller: controller.searchTextFieldController,
      onChanged: (value) {
        if (value.trim() == '') {
          controller.resetSearchPage();
        }
      },
      keyboardType: TextInputType.name,
      textDirection: TextDirection.rtl,
      color: (CommonFunctions.isLightMode(context))
          ? Colors.white
          : AppColors.darkThemeBackgroundColor,
      shadowColor: CommonFunctions.isLightMode(context)
          ? AppColors.primaryColor.withOpacity(0.36)
          : Colors.black38,
      elevation: 15,
      icon: Icons.search_rounded,
      hintText: _getHintText(currentOption),
    );
  }

  String _getHintText(SearchOption currentOption) {
    switch (currentOption) {
      case SearchOption.doctors:
        return 'اكتب إسم الطبيب';
      case SearchOption.users:
        return 'اكتب إسم المستخدم';
      case SearchOption.clinics:
        return '';
      case SearchOption.posts:
        return 'اكتب شئ من المنشور';
    }
  }
}
