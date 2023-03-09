import 'package:clinic/data/models/doctor_model.dart';
import 'package:clinic/data/models/user_model.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';

class ParentUserProvider extends InheritedWidget {
  final UserType userType;
  final DoctorModel? doctorModel = DoctorModel();
  final UserModel? userModel = UserModel();
  ParentUserProvider({super.key, required super.child, required this.userType})
      : super();
  @override
  bool updateShouldNotify(ParentUserProvider oldWidget) {
    if (userType == UserType.doctor) {
      return oldWidget.doctorModel != doctorModel;
    }
    return oldWidget.userModel != userModel;
  }

  static ParentUserProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();
}
