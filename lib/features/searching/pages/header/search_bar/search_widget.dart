import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/model/search_option.dart';
import 'package:clinic/features/searching/pages/header/search_bar/search_text_field.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 5,
          left: 5,
        ),
        child: GetBuilder<SearchPageController>(
          builder: (controller) {
            bool isClinics = (controller.currentOption == SearchOption.clinics);
            return Row(
              mainAxisSize: isClinics ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: isClinics
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                CircleButton(
                  onPressed: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                    controller.search(true);
                  },
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(isClinics ? 10.0 : 0.0),
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: isClinics ? 30 : null,
                    ),
                  ),
                ),
                if (!isClinics)
                  SizedBox(
                    width: 200,
                    child: SearchTextField(
                      currentOption: controller.currentOption,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
