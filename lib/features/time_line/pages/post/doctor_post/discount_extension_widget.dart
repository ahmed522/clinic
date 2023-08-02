import 'package:clinic/features/time_line/pages/post/doctor_post/add_clinics_widget.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/add_selected_clinics_dialog.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/set_discount_value_widget.dart';
import 'package:flutter/material.dart';

class DiscountExtensionWidget extends StatelessWidget {
  const DiscountExtensionWidget({super.key, required this.discount});
  final int discount;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SetDiscountValueWidget(discount: discount),
        const SizedBox(height: 30),
        AddClinicsWidget(
          title: 'العيادات المخفضة',
          onAddClinicPressed: () => _addClinic(context),
        ),
      ],
    );
  }

  Future<void> _addClinic(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const AddSelectedClinicDialog(),
    );
  }
}
