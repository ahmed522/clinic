import 'package:clinic/global/constants/gender.dart';
import 'package:flutter/material.dart';

import 'am_or_pm.dart';

class AppConstants {
  static const int passwordLength = 8;
  static int doctorMinimumBirthDateYear = DateTime.now().year - 23;
  static int userMinimumBirthDateYear = DateTime.now().year - 10;
  static const double dayBulletPhoneSize = 32.0;
  static const double dayBulletTabletSize = 45.0;
  static const double dayFontPhoneSize = 9.0;
  static const double dayFontTabletSize = 12.0;
  static const double phoneWidth = 420.0;
  static const double phoneheight = 750.0;
  static const Size phoneSize = Size(phoneWidth, phoneheight);
  static const String emailValidationRegExp =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const String nameValidationRegExp =
      r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
  static const String urlRegex =
      r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?';
  static const String phoneNumberRegex =
      r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$';
  static const String vezeetaValidationRegExp = r"^[0-9]*$";
  static const String zero = '0';

  static const String baseFCMUrl = 'https://fcm.googleapis.com/fcm/send';
  static const String fcmAutherizationKey =
      'AAAAs-thRzo:APA91bE7MaNacc3obm7fk66gATMw_szUooBSXpL4j_119nSHW-aLpUJHvI_zbfUxV64Mijut4tuas7xHa-pcq-G2pUoOZz9DzAK28blIF4ujnx0iTWucklGGVs9zIC1F5AiXTaLXP8tr';
  static const String userStandardPic =
      'https://firebasestorage.googleapis.com/v0/b/tabib-56f14.appspot.com/o/assets%2Fuser.png?alt=media&token=c74cec98-a38b-4602-87c1-3603d5832386';
  static const String tabibGroupMail = 'tabibgroup23@gmail.com';
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
  static const List<String> doctorSpecializationsIcons = [
    'assets/img/specs/general_practitioner.png',
    'assets/img/specs/emergency-doctor.png',
    'assets/img/specs/cardiologist.png',
    'assets/img/specs/cardiovascular.png',
    'assets/img/specs/neurologist.png',
    'assets/img/specs/dermatology.png',
    'assets/img/specs/ent.png',
    'assets/img/specs/hematology.png',
    'assets/img/specs/oncology.png',
    'assets/img/specs/radiography.png',
    'assets/img/specs/bone.png',
    'assets/img/specs/tooth.png',
    'assets/img/specs/oculist.png',
    'assets/img/specs/audiologist.png',
    'assets/img/specs/pediatrics.png',
    'assets/img/specs/pacifier.png',
    'assets/img/specs/fallopian.png',
    'assets/img/specs/psychology.png',
    'assets/img/specs/stomach.png',
    'assets/img/specs/surgery.png',
    'assets/img/specs/anesthesia.png',
  ];

  static Map<String, String> specializationsIcons =
      Map<String, String>.fromIterables(
          doctorSpecializations, doctorSpecializationsIcons);
  static const String signinWithGoogle = 'أو قم بتسجيل الدخول من خلال';
  static const String verifyEmail =
      'لقد تم إرسال رسالة التحقق إلى بريدك الإلكتروني، يمكنك العودة وتسجيل الدخول بعد التحقق';
  static String newDegreePostContent(String doctorName, Gender doctorGender) =>
      '${(doctorGender == Gender.male) ? ' حصل ' : ' حصلت '}${(doctorGender == Gender.male) ? 'الطبيب ' : 'الطبيبة '}$doctorName على درجة علمية جديدة';
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
