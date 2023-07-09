import 'package:flutter/material.dart';

import 'am_or_pm.dart';

class AppConstants {
  static const int passwordLength = 8;
  static int doctorMinimumBirthDateYear = DateTime.now().year - 23;
  static int userMinimumBirthDateYear = DateTime.now().year - 10;
  static const double dayBulletPhoneSize = 32.0;
  static const double dayBulletTabletSize = 45.0;
  static const double dayFontPhoneSize = 9.0;
  static const double dayFontTabletSize = 14.0;
  static const double phoneWidth = 420.0;
  static const double phoneheight = 750.0;
  static const Size phoneSize = Size(phoneWidth, phoneheight);
  static const String emailValidationRegExp =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const String vezeetaValidationRegExp = r"^[0-9]*$";
  static const String zero = '0';

  static const List<String> doctorDegrees = [
    'طبيب امتياز',
    'طبيب مقيم',
    'أخصائي',
    'أخصائي أول',
    'إستشاري',
    'استشاري أول',
    'بروفيسور',
  ];
  static const List<String> doctorSpecializations = [
    'طبيب عام',
    'طبيب طوارىء',
    'طبيب قلب',
    'طبيب القلب والأوعية الدموية',
    'طبيب مخ وأعصاب',
    'طبيب جلدية',
    'طبيب أنف وأذن وحنجرة',
    'طبيب أمراض الدم',
    'طبيب أورام',
    'طبيب أشعة',
    'طبيب عظام',
    'طبيب أسنان',
    'طبيب عيون',
    'طبيب سمعيات',
    'طبيب أطفال',
    'طبيب حديثي الولادة',
    'طبيب نساء وتوليد',
    'طبيب نفسي',
    'طبيب باطنة وجهاز هضمي',
    'طبيب جرًّاح',
    'طبيب تخدير',
  ];
  static const String doctorSpecializationsIconsURLStart =
      'https://firebasestorage.googleapis.com/v0/b/tabib-56f14.appspot.com/o/specs_icons%2F';
  static const List<String> doctorSpecializationsIconsURLs = [
    '${doctorSpecializationsIconsURLStart}general_practitioner.png?alt=media&token=03ea87ab-bc5a-4fd0-a31d-eb9ddadaa785',
    '${doctorSpecializationsIconsURLStart}emergency_doctor.png?alt=media&token=a14826c3-a72b-4956-a150-780cf3842c36',
    '${doctorSpecializationsIconsURLStart}cardiologist.png?alt=media&token=4a0e237e-be4a-4b7c-8fbd-00570797b260',
    '${doctorSpecializationsIconsURLStart}cardiovascular.png?alt=media&token=1bc8b0cb-a3a5-498d-ac93-d44fef204f85',
    '${doctorSpecializationsIconsURLStart}neurologist.png?alt=media&token=49b3143b-9f2e-436c-8252-6a7b80436aef',
    '${doctorSpecializationsIconsURLStart}dermatology.png?alt=media&token=af029ad4-ce76-4a9b-a569-cf390a4f5a7d',
    '${doctorSpecializationsIconsURLStart}ent.png?alt=media&token=c4f77952-609e-48f2-9357-a15f12e35d5c',
    '${doctorSpecializationsIconsURLStart}hematology.png?alt=media&token=0390263b-8bbe-459d-8a4d-88a3a92955f7',
    '${doctorSpecializationsIconsURLStart}oncology.png?alt=media&token=b4208e36-aa45-4c2d-8012-adf1cde5f0f2',
    '${doctorSpecializationsIconsURLStart}radiography.png?alt=media&token=0e6ff032-3f29-4708-87e4-57109dc4197c',
    '${doctorSpecializationsIconsURLStart}bone.png?alt=media&token=de12044e-1291-41a1-b2ad-b5f532a47362',
    '${doctorSpecializationsIconsURLStart}tooth.png?alt=media&token=433fdc3c-783d-43b2-864e-74b4b00cdb8b',
    '${doctorSpecializationsIconsURLStart}oculist.png?alt=media&token=be14def3-57df-4d9d-9f26-d1bc8456aa52',
    '${doctorSpecializationsIconsURLStart}audiologist.png?alt=media&token=44b30dfd-4e80-4a26-aa39-e4a41bae2edb',
    '${doctorSpecializationsIconsURLStart}pediatrics.png?alt=media&token=9a2cca23-cad1-4c7a-a85d-8c2bdc5a290f',
    '${doctorSpecializationsIconsURLStart}pacifier.png?alt=media&token=cfe8b940-6f95-40d9-95de-caf0d260f3bf',
    '${doctorSpecializationsIconsURLStart}fallopian.png?alt=media&token=82941c80-316b-4fdc-b3be-332bb2155921',
    '${doctorSpecializationsIconsURLStart}psychology.png?alt=media&token=600a5922-eed0-4812-88de-eaa459fbd5e8',
    '${doctorSpecializationsIconsURLStart}stomach.png?alt=media&token=bf3695dd-d55a-4469-99c2-b8a34c4ff07c',
    '${doctorSpecializationsIconsURLStart}surgery.png?alt=media&token=5b0b12bb-1ebd-4033-95dc-4ea194a87054',
    '${doctorSpecializationsIconsURLStart}anesthesia.png?alt=media&token=ebe2da1d-714f-4c1d-b22e-24d1cfd4b9f9',
  ];

  static Map<String, String> specializationsIcons =
      Map<String, String>.fromIterables(
          doctorSpecializations, doctorSpecializationsIconsURLs);
  static const String signinWithGoogle = 'أو قم بتسجيل الدخول من خلال';
  static const String verifyEmail =
      'لقد تم إرسال رسالة التحقق إلى بريدك الإلكتروني، يمكنك العودة وتسجيل الدخول بعد التحقق';
  static const String passwordReset =
      'سوف يتم إرسال رسالة إعادة التعيين إلى بريدك الإلكتروني، يمكنك العودة وتسجيل الدخول بعد إعادة تعيين كلمة المرور';

  static const String whyMedicalId =
      ' تطبيق طبيب هو تطبيق تواصل إجتماعي تفاعلي بين الأطباء والمستخدمين العاديين لكي يمكنهم من الإستفسار عن المعلومات الطبية أو حتى مراسلة طبيب والإستفسار عن الحالة المرضية ولذلك يجب أن نتأكد أن كل الأطباء المتواجدين على التطبيق هم ممن يحق له مزاولة المهنة وتشخيص الحالات المرضية ووصف العلاج حتى نحافظ على صحة المستخدمين وسلامتهم';
  static const String whereIsRestGovernorates =
      'نعمل دائما على تطوير تطبيق طبيب وتغطية نطاق أعلى من المحافظات، ترقب الإصدارات القادمة من التطبيق ';
  static const String regionInfo =
      'اختر المنطقة بشكل صحيح ومحدد للحصول على أفضل خدمة، إن لم تكن منطقتك موجودة في القائمة إختر أقرب منطقة لها';
  static const String whyPersonalImage =
      'يجب ان تكون الصورة الشخصية واضحة ورسمية قدر الإمكان';
  static const String doctorBirthDateRequirements =
      'يجب ألا يقل عمر الطبيب عن 23 عام';
  static const String userBirthDateRequirements =
      'يجب ألا يقل عمر المستخدم عن 10 أعوام';

  static const String passwordRequirements =
      'أحرف كبيرة \nأحرف صغيرة\nأرقام\nويجب أن لا تقل عن $passwordLength أحرف';
  static const String userNameRequirements =
      'يجب أن يكون الإسم واضح وحقيقي وغير مستعار';
  static const String initialDoctorDegree = 'طبيب امتياز';
  static const String initialDoctorSpecialization = 'طبيب عام';
  /* Clinic constants */
  static const List<String> weekDays = [
    'جمعة',
    'خميس',
    'أربع',
    'ثلاث',
    'أثنين',
    'أحد',
    'سبت',
  ];
  static List<bool> initialCheckedDays = [
    false,
    true,
    true,
    true,
    true,
    true,
    false,
  ];
  static const TimeOfDay initialOpenTime = TimeOfDay(hour: 15, minute: 0);
  static const TimeOfDay initialCloseTime = TimeOfDay(hour: 23, minute: 0);
  static const Map<String, bool> initialWorkDays = {
    'جمعة': false,
    'خميس': true,
    'أربع': true,
    'ثلاث': true,
    'أثنين': true,
    'أحد': true,
    'سبت': false,
  };
  static const String initialOpenTimeFinalMin = '00';
  static const String initialOpenTimeFinalHour = '3';
  static const String initialCloseTimeFinalMin = '00';
  static const String initialCloseTimeFinalHour = '11';
  static const AMOrPM initialAmOrPm = AMOrPM.pm;
  static const String initialClinicGovernorate = 'القاهرة';
  static const String initialClinicRegion = 'حلوان';
  static const int initialExamineVezeeta = 0;
  static const int initialReexamineVezeeta = 0;
  /* ==================== */

}
/*
 
 طبيب عام                                 General practitioner
طبيب الطوارىء                          Emergency Physician
طبيب القلب                               Cardiologist
طبيب القلب والأوعية الدموية        Cardiovascular
طبيب مخ وأعصاب                       Neurophysiologist
طبيب جلدية                              Dermatologist
طبيب أنف وأذن وحنجرة               ENT Specialist
طبيب أمراض الدم                      Hematologist
طبيب أورام                              Oncologist
طبيب الأشعة                            Radiologist
طبيب العظام                            Orthopedist
طبيب الأسنان                           Dentist
طبيب العيون                            Ophthalmologist
طبيب السمعيات                        Audiologist
طبيب ألأطفال                          Pediatrician
طبيب النساء والتوليد                 Gynecology and Obstetrics
طبيب حديثي الولادة                  Neonatologist
طبيب نفسي                            Psychiatrist
طبيب الباطنة والجهاز الهضمي    Gastroenterology
طبيب جرًّاح                              Surgeon
طبيب الروماتيزم                      Rheumatologist
طبيب التخدير                           Anesthesiologist          
  */
