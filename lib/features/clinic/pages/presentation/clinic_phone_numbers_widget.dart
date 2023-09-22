import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/clinic/pages/presentation/clinic_phone_number_list_tile.dart';
import 'package:flutter/material.dart';

class ClinicPhoneNumbersWidget extends StatelessWidget {
  const ClinicPhoneNumbersWidget(
      {super.key,
      this.clinicIndex,
      required this.isDoctorPost,
      this.clinicModel});
  final int? clinicIndex;
  final bool isDoctorPost;
  final ClinicModel? clinicModel;
  @override
  Widget build(BuildContext context) {
    ClinicModel clinic;
    if (isDoctorPost) {
      clinic = clinicModel!;
    } else {
      final controller = DoctorClinicsController.find;
      clinic = controller.clinics[clinicIndex!];
    }
    if (clinic.phoneNumbers.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          'أرقام الهواتف',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(height: 20),
        ...List<ClinicPhoneNumberListTile>.generate(
          clinic.phoneNumbers.length,
          (index) => ClinicPhoneNumberListTile(
            phoneNumber: clinic.phoneNumbers[index],
          ),
        ),
      ],
    );
  }
}
