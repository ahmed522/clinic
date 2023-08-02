import 'package:clinic/features/time_line/pages/post/doctor_post/add_clinics_widget.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/add_selected_clinics_dialog.dart';
import 'package:flutter/material.dart';

class NewClinicExtensionWidget extends StatelessWidget {
  const NewClinicExtensionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AddClinicsWidget(
        onAddClinicPressed: () => _addClinic(context),
        title: 'العيادات الجديدة');
  }

  Future<void> _addClinic(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const AddSelectedClinicDialog(),
    );
  }
}
