import 'package:clinic/features/searching/model/filter_type.dart';
import 'package:clinic/features/searching/model/search_option.dart';

class FilterModel {
  FilterModel({required this.searchOption, required this.filterType}) {
    content = _filterContent;
    switch (filterType) {
      case FilterType.doctorSpecializationItem:
      case FilterType.doctorDegreeItem:
      case FilterType.clinicGovernorateItem:
      case FilterType.clinicRegionItem:
        active = true;
        break;
      default:
        active = false;
    }
  }
  final SearchOption searchOption;
  final FilterType filterType;
  late String content;
  late bool active;

  String get _filterContent {
    switch (filterType) {
      case FilterType.doctorSpecialization:
        return 'التخصص';
      case FilterType.doctorSpecializationItem:
        return 'طبيب عام';
      case FilterType.doctorDegree:
        return 'الدرجة العلمية';
      case FilterType.doctorDegreeItem:
        return 'أخصائي';
      case FilterType.isFollowing:
        return 'المتابَعون';
      case FilterType.isFollower:
        return 'المتابِعون';
      case FilterType.clinicGovernorate:
        return 'المحافظة';
      case FilterType.clinicGovernorateItem:
        return 'القاهرة';
      case FilterType.clinicRegion:
        return 'المنطقة';
      case FilterType.clinicRegionItem:
        return 'حلوان';
      case FilterType.clinicVezeeta:
        return 'سعر الكشف';
      case FilterType.isUserPost:
        return 'أسئلة المستخدمين';
      case FilterType.isDoctorPost:
        return 'منشورات الأطباء';
    }
  }
}
