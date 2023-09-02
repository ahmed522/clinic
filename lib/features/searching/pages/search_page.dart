import 'package:clinic/global/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height / 6),
        child: const AppBarWidget(text: '        البحث'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SvgPicture.asset('assets/img/search.svg'),
      ),
    );
  }
}
