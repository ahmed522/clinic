import 'package:clinic/features/searching/pages/header/top_bar/search_popup_menu_button.dart';
import 'package:flutter/material.dart';

class SearchPageHeaderTopBarContentWidget extends StatelessWidget {
  const SearchPageHeaderTopBarContentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          SearchPopupMenuButton(),
          Text(
            'البحث',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              shadows: [
                BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
