import 'package:flutter/material.dart';

import 'am_or_pm.dart';

class AppConstants {
  static const int passwordLength = 8;
  static const int doctorMinimumAge = 23;
  static const int userMinimumAge = 7;
  static const int wrongAgeErrorCode = 101;

  static const double dayBulletPhoneSize = 33.0;
  static const double dayBulletTabletSize = 45.0;
  static const double dayFontPhoneSize = 12.0;
  static const double dayFontTabletSize = 14.0;
  static const double phoneWidth = 370.0;
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
  static const List<String> doctorSpecializationsIcons = [
    'assets/img/specializations/general_practitioner.png',
    'assets/img/specializations/emergency_doctor.png',
    'assets/img/specializations/cardiologist.png',
    'assets/img/specializations/cardiovascular.png',
    'assets/img/specializations/neurologist.png',
    'assets/img/specializations/dermatology.png',
    'assets/img/specializations/ent.png',
    'assets/img/specializations/hematology.png',
    'assets/img/specializations/oncology.png',
    'assets/img/specializations/radiography.png',
    'assets/img/specializations/bone.png',
    'assets/img/specializations/tooth.png',
    'assets/img/specializations/oculist.png',
    'assets/img/specializations/audiologist.png',
    'assets/img/specializations/pediatrics.png',
    'assets/img/specializations/pacifier.png',
    'assets/img/specializations/fallopian.png',
    'assets/img/specializations/psychology.png',
    'assets/img/specializations/stomach.png',
    'assets/img/specializations/surgery.png',
    'assets/img/specializations/anesthesia.png',
  ];
  static Map<String, String> specializationsIcons =
      Map<String, String>.fromIterables(
          doctorSpecializations, doctorSpecializationsIcons);
  static const String signinWithGoogle = 'أو قم بتسجيل الدخول من خلال';
  static const String verifyEmail =
      'لقد تم إرسال رسالة التحقق إلى بريدك الإلكتروني، يمكنك العودة وتسجيل الدخول بعد التحقق';
  static const String passwordReset =
      'سوف يتم إرسال رسالة إعادة التعيين إلى بريدك الإلكتروني، يمكنك العودة وتسجيل الدخول بعد إعادة تعيين كلمة المرور';

  static const String whyMedicalId =
      ' تطبيق طبي هو تطبيق تواصل إجتماعي تفاعلي بين الأطباء والمستخدمين العاديين لكي يمكنهم من الإستفسار عن المعلومات الطبية أو حتى مراسلة طبيب والإستفسار عن الحالة المرضية ولذلك يجب أن نتأكد أن كل الأطباء المتواجدين على التطبيق هم ممن يحق له مزاولة المهنة وتشخيص الحالات المرضية ووصف العلاج حتى نحافظ على صحة المستخدمين وسلامتهم';
  static const String whereIsRestGovernorates =
      'نعمل دائما على تطوير تطبيق طبي وتغطية نطاق أعلى من المحافظات، ترقب الإصدارات القادمة من التطبيق ';
  static const String regionInfo =
      'اختر المنطقة بشكل صحيح ومحدد للحصول على أفضل خدمة، إن لم تكن منطقتك موجودة في القائمة إختر أقرب منطقة لها';
  static const String whyPersonalImage =
      'يجب ان تكون الصورة الشخصية واضحة ورسمية قدر الإمكان';
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

