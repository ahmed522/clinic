import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/clinic/pages/presentation/from_search_single_clinic_page.dart';
import 'package:clinic/features/clinic/pages/presentation/single_clinic_item.dart';
import 'package:clinic/features/following/pages/follower_card.dart';
import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/model/search_option.dart';
import 'package:clinic/features/searching/pages/header/search_page_header.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/doctor_post_widget.dart';
import 'package:clinic/features/time_line/pages/post/user_post/user_post_widget.dart';

import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/empty_page.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchPageController());
    return Scaffold(
      body: OfflinePageBuilder(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            currentFocus.unfocus();
          },
          child: NestedScrollView(
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: SearchPageHeader(),
                ),
              ];
            }),
            body: const SearchPageContent(),
          ),
        ),
      ),
    );
  }
}

class SearchPageContent extends StatelessWidget {
  const SearchPageContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<SearchPageController>(
      builder: (controller) {
        if (controller.loadingItems) {
          return SizedBox(
            height: size.height - 100,
            child: const Center(
              child: AppCircularProgressIndicator(
                height: 80,
                width: 80,
              ),
            ),
          );
        }
        if (controller.noResults) {
          return SizedBox(
            height: size.height - 100,
            child: const EmptyPage(
              text: 'لا توجد نتائج',
            ),
          );
        }
        if (controller.searchedClinics.isEmpty &&
            controller.searchedDoctors.isEmpty &&
            controller.searchedUsers.isEmpty &&
            controller.searchedPosts.isEmpty) {
          return SizedBox(
            height: size.height - 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SvgPicture.asset(
                'assets/img/search.svg',
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: (controller.currentOption == SearchOption.doctors)
              ? controller.searchedDoctors.length
              : (controller.currentOption == SearchOption.users)
                  ? controller.searchedUsers.length
                  : (controller.currentOption == SearchOption.clinics)
                      ? controller.searchedClinics.length
                      : controller.searchedPosts.length,
          itemBuilder: (context, index) {
            switch (controller.currentOption) {
              case SearchOption.doctors:
                return FollowerCard(
                    follower: controller.searchedDoctors[index]);
              case SearchOption.users:
                return FollowerCard(follower: controller.searchedUsers[index]);

              case SearchOption.clinics:
                ClinicModel clinic = controller.searchedClinics[index];
                return SingleClinicItem(
                  clinic: clinic,
                  onTap: () => Get.to(
                    () => FromSearchSingleClinicPage(clinic: clinic),
                    transition: Transition.rightToLeftWithFade,
                  ),
                );

              case SearchOption.posts:
                return (controller.searchedPosts[index].writerType! ==
                        UserType.doctor)
                    ? DoctorPostWidget(
                        post:
                            controller.searchedPosts[index] as DoctorPostModel,
                      )
                    : UserPostWidget(
                        post: controller.searchedPosts[index] as UserPostModel,
                        isProfilePage: false,
                      );
            }
          },
        );
      },
    );
  }
}
