import 'package:flutter/material.dart';

class SetClinicVezeetaForm extends StatelessWidget {
  const SetClinicVezeetaForm({
    Key? key,
    required this.formKey,
    required this.examineVezeetaValidator,
    required this.reexamineVezeetaValidator,
    this.examineVezeeta,
    this.reexamineVezeeta,
  }) : super(key: key);

  final Key formKey;
  final String? Function(String? value) examineVezeetaValidator;
  final String? Function(String? value) reexamineVezeetaValidator;
  final int? examineVezeeta;
  final int? reexamineVezeeta;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'سعر الكشف',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) => examineVezeetaValidator(value),
                  keyboardType: TextInputType.number,
                  initialValue: (examineVezeeta == null)
                      ? null
                      : examineVezeeta.toString(),
                  maxLength: 4,
                  decoration: const InputDecoration(
                    counter: Offstage(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'سعر الإستشارة',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) => reexamineVezeetaValidator(value),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  initialValue: (reexamineVezeeta == null)
                      ? null
                      : reexamineVezeeta.toString(),
                  decoration: const InputDecoration(
                    counter: Offstage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
