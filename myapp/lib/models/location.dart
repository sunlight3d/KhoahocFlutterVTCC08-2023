class Location {
  final String city;
  final String state;
  final String country;
  final int postcode;

  Location({
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
  });
  static Location get empty {
    return Location(
      city: '',
      state: '',
      country: '',
      postcode: 0
    );
  }
}