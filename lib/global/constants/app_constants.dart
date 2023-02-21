import 'package:flutter/material.dart';

import 'am_or_pm.dart';

class AppConstants {
  static const int passwordLength = 8;
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
    'طبيب عام ',
    'طبيب طوارىء ',
    'طبيب قلب ',
    'طبيب مخ وأعصاب ',
    'طبيب جلدية ',
    'طبيب أنف وأذن وحنجرة ',
    'طبيب أمراض الدم ',
    'طبيب أورام ',
    'طبيب أشعة ',
    'طبيب عظام ',
    'طبيب أسنان ',
    'طبيب عيون ',
    'طبيب سمعيات ',
    'طبيب أطفال ',
    'طبيب نساء وتوليد ',
    'طبيب نفسي ',
    'طبيب باطنة وجهاز هضمي ',
    'طبيب جرًّاح ',
    'طبيب تخدير ',
  ];
  static const List<String> regions = [
    'حلوان',
  ];
  static const String whyMedicalId =
      ' تطبيق طبي هو تطبيق تواصل إجتماعي تفاعلي بين الأطباء والمستخدمين العاديين لكي يمكنهم من الإستفسار عن المعلومات الطبية أو حتى مراسلة طبيب والإستفسار عن الحالة المرضية ولذلك يجب أن نتأكد أن كل الأطباء المتواجدين على التطبيق هم ممن يحق له مزاولة المهنة وتشخيص الحالات المرضية ووصف العلاج حتى نحافظ على صحة المستخدمين وسلامتهم';
  static const String whereIsRestRegions =
      'نعمل دائما على تطوير تطبيق طبي وتغطية نطاق أعلى من المناطق، ترقب الإصدارات القادمة من التطبيق ';
  static const String whyPersonalImage =
      'يجب ان تكون الصورة الشخصية واضحة ورسمية قدر الإمكان';
  static const String passwordRequirements =
      'أحرف كبيرة \nأحرف صغيرة\nأرقام\nويجب أن لا تقل عن $passwordLength أحرف';
  static const String userNameRequirements =
      'يجب أن يكون الإسم واضح وحقيقي وغير مستعار';
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

