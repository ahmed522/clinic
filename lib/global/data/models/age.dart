class Age {
  late final int years;
  late final int months;
  late final int days;

  Age({required this.years, required this.months, required this.days});
  toJson() {
    Map<String, int> data = {};
    data['years'] = years;
    data['months'] = months;
    data['days'] = days;
    return data;
  }

  Age.fromJson(Map<String, dynamic> data) {
    years = data['years'];
    months = data['months'];
    days = data['days'];
  }
}
