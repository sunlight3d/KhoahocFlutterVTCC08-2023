class Picture {
  final String large;
  final String medium;
  final String thumbnail;

  Picture({
    required this.large,
    required this.medium,
    required this.thumbnail,
  });
  static Picture get empty {
    return Picture(
      large: '',
      medium: '',
      thumbnail: '',
    );
  }
}