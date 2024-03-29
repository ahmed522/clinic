import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:flutter/material.dart';

class MedicalRecordItemParentWidget extends StatelessWidget {
  const MedicalRecordItemParentWidget({
    Key? key,
    this.onEditItemButtonPressed,
    this.onRemoveItemButtonPressed,
    required this.itemName,
    this.itemInfo,
    this.surgeryDate,
    this.isMedicalRecordPage = false,
  }) : super(key: key);
  final void Function()? onEditItemButtonPressed;
  final void Function()? onRemoveItemButtonPressed;
  final String itemName;
  final String? itemInfo;
  final String? surgeryDate;
  final bool isMedicalRecordPage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
            width: .0001,
          ),
        ),
        color: (CommonFunctions.isLightMode(context))
            ? Colors.white
            : AppColors.darkThemeBottomNavBarColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isMedicalRecordPage
                  ? const SizedBox()
                  : Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleButton(
                            onPressed: () => onEditItemButtonPressed!(),
                            child: const Icon(Icons.edit_rounded),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CircleButton(
                            backgroundColor: Colors.red,
                            onPressed: () => onRemoveItemButtonPressed!(),
                            child: const Icon(Icons.remove_rounded),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                width: isMedicalRecordPage ? 0 : 5,
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      itemName,
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        color: (CommonFunctions.isLightMode(context))
                            ? Colors.black
                            : Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    (itemInfo != null)
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              itemInfo!,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontFamily: AppFonts.mainArabicFontFamily,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: (CommonFunctions.isLightMode(context))
                                    ? Colors.black87
                                    : Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 5),
                    (surgeryDate != null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  'تاريخ إجراء العملية',
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  surgeryDate!,
                                  style: TextStyle(
                                    fontFamily: AppFonts.mainArabicFontFamily,
                                    color:
                                        (CommonFunctions.isLightMode(context))
                                            ? Colors.black
                                            : Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
