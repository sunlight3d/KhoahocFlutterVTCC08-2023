import 'package:myapp/models/location.dart';
import 'package:myapp/models/picture.dart';

class User {
  final String gender;
  final String name;
  final Location location;
  final String email;
  final DateTime dob;
  final String userName;
  final String userId;
  final Picture picture;

  User({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.dob,
    required this.userName,
    required this.userId,
    required this.picture,
  });
  static User get empty {
    return User(
      gender: '',
      name: '',
      location: Location.empty,
      email: '',
      dob: DateTime(1900, 1, 1),
      userName: '',
      userId: '',
      picture: Picture.empty,
    );
  }
  factory User.fromJson(Map<String, dynamic> dictionary) {
    return User(
      gender: dictionary['gender'] ?? '',
      name: '${dictionary['name']['title'] ?? ''} '
          '${dictionary['name']['first'] ?? ''} '
          '${dictionary['name']['last'] ?? ''}',
      location: Location(
        city: dictionary['location']['city'] ?? '',
        state: dictionary['location']['state'] ?? '',
        country: dictionary['location']['country'] ?? '',
        postcode: dictionary['location']['postcode'] ?? '',
      ),
      email: dictionary['email'] ?? '',
      dob: DateTime.parse(dictionary['dob']['date'] ?? '1900-01-01'),
      userName: dictionary['login']['username'] ?? '',
      userId: dictionary['login']['uuid'] ?? '',
      picture: Picture(
        large: dictionary['picture']['large'] ?? '',
        medium: dictionary['picture']['medium'] ?? '',
        thumbnail: dictionary['picture']['thumbnail'] ?? '',
      ),
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.gender == gender &&
        other.name == name &&
        //other.location == location &&
        other.email == email &&
        other.dob == dob &&
        other.userName == userName &&
        other.userId == userId &&
        other.picture == picture;
  }
  @override
  int get hashCode {
    return gender.hashCode ^
    name.hashCode ^
    location.hashCode ^
    email.hashCode ^
    dob.hashCode ^
    userName.hashCode ^
    userId.hashCode ^
    picture.hashCode;
  }
}
