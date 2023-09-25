import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/features/searching/model/filter_model.dart';
import 'package:clinic/features/searching/model/filter_type.dart';
import 'package:clinic/features/searching/model/search_option.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  static SearchPageController get find => Get.find<SearchPageController>();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;
  final TextEditingController searchTextFieldController =
      TextEditingController();
  SearchOption currentOption = SearchOption.doctors;
  List<String> selectedFilters = [];
  List<FollowerModel> searchedDoctors = [];
  List<FollowerModel> searchedUsers = [];
  List<ParentPostModel> searchedPosts = [];
  List<ClinicModel> searchedClinics = [];
  int maximumVezeeta = 100;
  int tempMaximumVezeeta = 100;
  bool noResults = false;
  bool loadingItems = false;
  bool moreItemsLoading = false;

  List<FilterModel> filters = [
    FilterModel(
      searchOption: SearchOption.doctors,
      filterType: FilterType.doctorSpecialization,
    ),
    FilterModel(
      searchOption: SearchOption.doctors,
      filterType: FilterType.doctorDegree,
    ),
  ];
  updateCurrentOption(SearchOption searchOption) {
    if (searchOption != currentOption) {
      currentOption = searchOption;
      resetSearchPage();
      filters.clear();
      selectedFilters.clear();
      switch (searchOption) {
        case SearchOption.doctors:
          filters = [
            FilterModel(
              searchOption: SearchOption.doctors,
              filterType: FilterType.doctorSpecialization,
            ),
            FilterModel(
              searchOption: SearchOption.doctors,
              filterType: FilterType.doctorDegree,
            ),
          ];
          break;

        case SearchOption.users:
          filters.addIf(
            (CommonFunctions.currentUserType == UserType.doctor),
            FilterModel(
              searchOption: SearchOption.users,
              filterType: FilterType.isFollower,
            ),
          );
          break;
        case SearchOption.clinics:
          filters = [
            FilterModel(
              searchOption: SearchOption.clinics,
              filterType: FilterType.doctorSpecialization,
            ),
            FilterModel(
              searchOption: SearchOption.clinics,
              filterType: FilterType.clinicGovernorate,
            ),
            FilterModel(
              searchOption: SearchOption.clinics,
              filterType: FilterType.clinicRegion,
            ),
            FilterModel(
              searchOption: SearchOption.clinics,
              filterType: FilterType.clinicVezeeta,
            ),
          ];
          break;
        case SearchOption.posts:
          filters = [
            FilterModel(
              searchOption: SearchOption.posts,
              filterType: FilterType.isUserPost,
            ),
            FilterModel(
              searchOption: SearchOption.posts,
              filterType: FilterType.isDoctorPost,
            ),
          ];
          break;
      }
    }
    update();
  }

  selectFilter(FilterModel selectedFilter, bool value) {
    if (value) {
      if (selectedFilter.filterType == FilterType.clinicGovernorateItem) {
        filters.removeWhere(
          (element) {
            if ((element.filterType == FilterType.clinicRegionItem) ||
                (element.filterType == FilterType.clinicGovernorateItem)) {
              selectedFilters.remove(element.content);
              return true;
            }
            return false;
          },
        );
        if (!filters
            .any((element) => element.filterType == FilterType.clinicRegion)) {
          filters.add(
            FilterModel(
              searchOption: SearchOption.clinics,
              filterType: FilterType.clinicRegion,
            ),
          );
        }
      }
      selectedFilters.add(selectedFilter.content);
      filters.add(selectedFilter);
      switch (selectedFilter.filterType) {
        case FilterType.doctorSpecializationItem:
          filters.removeWhere((element) =>
              element.filterType == FilterType.doctorSpecialization);
          break;
        case FilterType.doctorDegreeItem:
          filters.removeWhere(
              (element) => element.filterType == FilterType.doctorDegree);
          break;
        case FilterType.clinicGovernorateItem:
          filters.removeWhere(
              (element) => element.filterType == FilterType.clinicGovernorate);
          break;
        case FilterType.clinicRegionItem:
          filters.removeWhere(
              (element) => element.filterType == FilterType.clinicRegion);
          break;
        default:
      }
    } else {
      selectedFilters.remove(selectedFilter.content);
      filters.removeWhere((item) => selectedFilter.content == item.content);
      switch (selectedFilter.filterType) {
        case FilterType.doctorSpecializationItem:
          if (!filters.any((element) =>
              element.filterType == FilterType.doctorSpecializationItem)) {
            filters.add(
              FilterModel(
                searchOption: selectedFilter.searchOption,
                filterType: FilterType.doctorSpecialization,
              ),
            );
          }
          break;
        case FilterType.doctorDegreeItem:
          if (!filters.any(
              (element) => element.filterType == FilterType.doctorDegreeItem)) {
            filters.add(
              FilterModel(
                searchOption: SearchOption.doctors,
                filterType: FilterType.doctorDegree,
              ),
            );
          }
          break;
        case FilterType.clinicGovernorateItem:
          if (!filters.any((element) =>
              element.filterType == FilterType.clinicGovernorateItem)) {
            filters.add(
              FilterModel(
                searchOption: SearchOption.clinics,
                filterType: FilterType.clinicGovernorate,
              ),
            );
          }
          filters.removeWhere(
            (element) {
              if (element.filterType == FilterType.clinicRegionItem) {
                selectedFilters.remove(element.content);
                return true;
              }
              return false;
            },
          );
          if (!filters.any(
              (element) => element.filterType == FilterType.clinicRegion)) {
            filters.add(
              FilterModel(
                searchOption: SearchOption.clinics,
                filterType: FilterType.clinicRegion,
              ),
            );
          }
          break;
        case FilterType.clinicRegionItem:
          if (!filters.any(
              (element) => element.filterType == FilterType.clinicRegionItem)) {
            filters.add(
              FilterModel(
                searchOption: SearchOption.clinics,
                filterType: FilterType.clinicRegion,
              ),
            );
          }
          break;
        default:
      }
    }
    update();
  }

  addVezeetaFilter() {
    maximumVezeeta = tempMaximumVezeeta;
    filters
        .singleWhere(
            (element) => element.filterType == FilterType.clinicVezeeta)
        .content = '${maximumVezeeta.toString()} EGP أقل من';
    filters
        .singleWhere(
            (element) => element.filterType == FilterType.clinicVezeeta)
        .active = true;
    update();
  }

  removeVezeetaFilter() {
    filters
        .singleWhere(
            (element) => element.filterType == FilterType.clinicVezeeta)
        .content = 'سعر الكشف';
    filters
        .singleWhere(
            (element) => element.filterType == FilterType.clinicVezeeta)
        .active = false;
    update();
  }

  updateFilterActive(FilterModel filter, bool active) {
    filters[filters.indexWhere((filterModel) => filterModel == filter)].active =
        active;
    update();
  }

  increamentMaximumClinicVezeeta() {
    if (tempMaximumVezeeta < 9999) {
      ++tempMaximumVezeeta;
    }
    update();
  }

  decrementMaximumClinicVezeeta() {
    if (tempMaximumVezeeta > 1) {
      --tempMaximumVezeeta;
    }
    update();
  }

  updateTempMaximumClinicVezeeta() {
    tempMaximumVezeeta = maximumVezeeta;
    update();
  }

  updateNoResults(bool value) {
    noResults = value;
    update();
  }

  updateLoadingItems(bool value) {
    loadingItems = value;
    update();
  }

  updateMoreItemsLoading(bool value) {
    moreItemsLoading = value;
    update();
  }

  resetSearchPage() {
    updateLoadingItems(false);
    updateNoResults(false);
    searchedDoctors.clear();
    searchedUsers.clear();
    searchedClinics.clear();
    searchedPosts.clear();
    update();
  }

  ///===========================================================================
  ///                                  Queries                                 =
  ///===========================================================================
  search(bool isRefresh) async {
    updateNoResults(false);
    String searchValue = searchTextFieldController.text.trim();
    switch (currentOption) {
      case SearchOption.posts:
        if (searchValue != '') {
          if (isRefresh) {
            updateLoadingItems(true);
          }
          updateMoreItemsLoading(true);
          bool isDoctorPost = false;
          bool isUserPost = false;
          if (filters.any((element) =>
              (element.filterType == FilterType.isDoctorPost &&
                  element.active))) {
            isDoctorPost = true;
          }
          if (filters.any((element) =>
              (element.filterType == FilterType.isUserPost &&
                  element.active))) {
            isUserPost = true;
          }
          if ((isDoctorPost && isUserPost) || (!(isDoctorPost || isUserPost))) {
            loadPosts(searchValue, isRefresh);
          } else if (isUserPost) {
            loadPosts(searchValue, isRefresh, userType: UserType.user);
          } else if (isDoctorPost) {
            loadPosts(searchValue, isRefresh, userType: UserType.doctor);
          }
        }
        break;
      case SearchOption.users:
        if (searchValue != '') {
          if (isRefresh) {
            updateLoadingItems(true);
          }
          updateMoreItemsLoading(true);
          if (filters.any((element) =>
              (element.filterType == FilterType.isFollower &&
                  element.active))) {
            loadUsers(searchValue, isRefresh, true);
          } else {
            loadUsers(searchValue, isRefresh, false);
          }
        }
        break;
      case SearchOption.doctors:
        if (searchValue != '') {
          if (isRefresh) {
            updateLoadingItems(true);
          }
          updateMoreItemsLoading(true);
          List<String> specializations = [];
          List<String> degrees = [];
          for (FilterModel element in filters) {
            if (element.filterType == FilterType.doctorSpecializationItem) {
              specializations.add(element.content);
            } else if (element.filterType == FilterType.doctorDegreeItem) {
              degrees.add(element.content);
            }
          }
          loadDoctors(
            searchValue,
            isRefresh,
            specializations: specializations,
            degrees: degrees,
          );
        }
        break;
      case SearchOption.clinics:
        if (isRefresh) {
          updateLoadingItems(true);
        }
        updateMoreItemsLoading(true);
        List<String> specializations = [];
        String? governorate;
        List<String> regions = [];
        bool filterExamineVezeeta = false;
        for (FilterModel element in filters) {
          if (element.filterType == FilterType.doctorSpecializationItem) {
            specializations.add(element.content);
          } else if (element.filterType == FilterType.clinicGovernorateItem) {
            governorate = element.content;
          } else if (element.filterType == FilterType.clinicRegionItem) {
            regions.add(element.content);
          } else if ((element.filterType == FilterType.clinicVezeeta) &&
              element.active) {
            filterExamineVezeeta = true;
          }
        }
        loadClinics(
          isRefresh,
          specializations: specializations,
          governorate: governorate,
          regions: regions,
          filterExamineVezeeta: filterExamineVezeeta,
        );
        break;
      default:
    }
  }

  /// --------------------------------posts-------------------------------------
  loadPosts(String searchValue, bool isRefresh, {UserType? userType}) async {
    Query query = _userDataController.searchForPostsQuery(searchValue,
        writerType: userType);
    query.get().then(
      (snapshot) async {
        if (snapshot.size == 0) {
          updateLoadingItems(false);
          updateMoreItemsLoading(false);
          if (isRefresh) {
            searchedPosts.clear();
            updateNoResults(true);
          }
        } else {
          if (isRefresh) {
            searchedPosts.clear();
          }

          for (var postSnapShot in snapshot.docs) {
            final String uid = postSnapShot.get('uid');
            final String postDocumentId = postSnapShot.id;
            final UserType writerType =
                postSnapShot.get('user_type') == 'doctor'
                    ? UserType.doctor
                    : UserType.user;
            if (writerType == UserType.user) {
              UserModel userModel;
              if (CommonFunctions.isCurrentUser(uid)) {
                userModel = _authenticationController.currentUser as UserModel;
              } else {
                userModel = await _userDataController.getUserById(uid);
              }
              UserPostModel post = UserPostModel.fromSnapShot(
                  postSnapShot:
                      postSnapShot as DocumentSnapshot<Map<String, dynamic>>,
                  writer: userModel);
              post.reacted = await _userDataController.isUserReactedPost(
                  _authenticationController.currentUserId, postDocumentId);
              searchedPosts.add(post);
            } else {
              DoctorModel doctorModel;
              if (CommonFunctions.isCurrentUser(uid)) {
                doctorModel =
                    _authenticationController.currentUser as DoctorModel;
              } else {
                doctorModel = await _userDataController.getDoctorById(uid);
              }
              DoctorPostModel post = DoctorPostModel.fromSnapShot(
                postSnapShot:
                    postSnapShot as DocumentSnapshot<Map<String, dynamic>>,
                writer: doctorModel,
              );

              post.reacted = await _userDataController.isUserReactedPost(
                  _authenticationController.currentUserId, postDocumentId);

              searchedPosts.add(post);
            }
            updateLoadingItems(false);
          }
          updateMoreItemsLoading(false);
        }
      },
    );
  }

  /// --------------------------------------------------------------------------

  /// --------------------------------users-------------------------------------
  loadUsers(String searchValue, bool isRefresh, bool isFollower) async {
    Query query = isFollower
        ? _userDataController.searchForFollowersUsersQuery(
            searchValue, currentUserId)
        : _userDataController.searchForUsersQuery(searchValue);

    query.get().then(
      (snapshot) async {
        if (snapshot.size == 0) {
          updateLoadingItems(false);
          updateMoreItemsLoading(false);
          if (isRefresh) {
            searchedUsers.clear();
            updateNoResults(true);
          }
        } else {
          if (isRefresh) {
            searchedUsers.clear();
          }

          for (var userSnapShot in snapshot.docs) {
            FollowerModel followerModel;
            if (isFollower) {
              followerModel = FollowerModel.fromSnapshot(
                userSnapShot as QueryDocumentSnapshot<Map<String, dynamic>>,
              );
              if (CommonFunctions.isCurrentUser(followerModel.userId)) {
                followerModel.userPersonalImage =
                    _authenticationController.currentUserPersonalImage;
              } else {
                followerModel.userPersonalImage =
                    await _userDataController.getUserPersonalImageURLById(
                        followerModel.userId, followerModel.userType);
              }
            } else {
              followerModel = FollowerModel(
                userType: UserType.user,
                userId: userSnapShot['uid'],
                userName: userSnapShot['user_name'],
                gender: userSnapShot['gender'] == 'male'
                    ? Gender.male
                    : Gender.female,
              );
              followerModel.userPersonalImage =
                  userSnapShot['personal_image_URL'];
            }
            searchedUsers.add(followerModel);
            updateLoadingItems(false);
          }
          updateMoreItemsLoading(false);
        }
      },
    );
  }

  /// --------------------------------------------------------------------------

  /// --------------------------------doctors-----------------------------------
  loadDoctors(
    String searchValue,
    bool isRefresh, {
    required List<String> specializations,
    required List<String> degrees,
  }) async {
    Query query = _userDataController.searchForDoctorsQuery(
      searchValue,
      specializations: specializations,
      degrees: degrees,
    );

    query.get().then(
      (snapshot) async {
        if (snapshot.size == 0) {
          updateLoadingItems(false);
          updateMoreItemsLoading(false);
          if (isRefresh) {
            searchedDoctors.clear();
            updateNoResults(true);
          }
        } else {
          if (isRefresh) {
            searchedDoctors.clear();
          }
          for (var doctorSnapShot in snapshot.docs) {
            if (degrees.isEmpty ||
                degrees.any((element) => element == doctorSnapShot['degree'])) {
              FollowerModel followerModel = FollowerModel(
                  userType: UserType.doctor,
                  userId: doctorSnapShot['uid'],
                  userName: doctorSnapShot['user_name'],
                  gender: doctorSnapShot['gender'] == 'male'
                      ? Gender.male
                      : Gender.female,
                  doctorSpecialization: doctorSnapShot['specialization']);
              followerModel.userPersonalImage =
                  doctorSnapShot['personal_image_URL'];
              searchedDoctors.add(followerModel);
              updateLoadingItems(false);
            }
          }
          if (searchedDoctors.isEmpty) {
            updateNoResults(true);
            updateLoadingItems(false);
          }
          updateMoreItemsLoading(false);
        }
      },
    );
  }

  /// --------------------------------------------------------------------------

  /// --------------------------------clinics-----------------------------------
  loadClinics(
    bool isRefresh, {
    required List<String> specializations,
    required String? governorate,
    required List<String> regions,
    required bool filterExamineVezeeta,
  }) async {
    Query query = _userDataController.searchForClinicsQuery(
      specializations: specializations,
      governorate: governorate,
      regions: regions,
      maximumVezeeta: filterExamineVezeeta ? maximumVezeeta : null,
    );

    query.get().then(
      (snapshot) async {
        if (snapshot.size == 0) {
          updateLoadingItems(false);
          updateMoreItemsLoading(false);
          if (isRefresh) {
            searchedClinics.clear();
            updateNoResults(true);
          }
        } else {
          if (isRefresh) {
            searchedClinics.clear();
          }

          for (var clinicSnapShot in snapshot.docs) {
            if (regions.isEmpty ||
                regions.any((element) => element == clinicSnapShot['region'])) {
              ClinicModel clinicModel = ClinicModel.fromSnapShot(
                  clinicSnapShot as DocumentSnapshot<Map<String, dynamic>>);
              clinicModel.doctorName =
                  await _userDataController.getUserNameById(
                clinicModel.doctorId!,
                UserType.doctor,
              );
              _userDataController
                  .getUserPersonalImageURLById(
                clinicModel.doctorId!,
                UserType.doctor,
              )
                  .then(
                (doctorPicUrl) {
                  clinicModel.doctorPic = doctorPicUrl;
                  update();
                },
              );
              _userDataController
                  .getUserGenderById(
                clinicModel.doctorId!,
                UserType.doctor,
              )
                  .then(
                (doctorGender) {
                  clinicModel.doctorGender = doctorGender;
                  update();
                },
              );
              searchedClinics.add(clinicModel);
              updateLoadingItems(false);
            }
          }
          if (searchedClinics.isEmpty) {
            updateNoResults(true);
            updateLoadingItems(false);
          }
          updateMoreItemsLoading(false);
        }
      },
    );
  }

  /// --------------------------------------------------------------------------

  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
}
