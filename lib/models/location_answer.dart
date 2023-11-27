class LocationAnswer {
  int locationId;
  bool status;
  String? issue;
  String? notes;

  LocationAnswer(
      {required this.locationId, required this.status, this.issue, this.notes});
}
