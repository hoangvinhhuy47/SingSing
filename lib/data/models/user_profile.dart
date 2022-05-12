class UserProfile {
  String userId = '';
  bool hasMasterPin = false;
  String username = '';
  String email = '';
  String firstName = '';
  String lastName = '';
  String nickname = '';
  String googleId = '';
  String facebookId = '';
  Map<String, String> attributes = {};
  String avatar = '';

  UserProfile(
      {required this.userId,
        required this.hasMasterPin,
        required this.username,
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.nickname,
        required this.googleId,
        required this.facebookId,
        required this.attributes,
        required this.avatar
      }
  );

  UserProfile.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? '';
    hasMasterPin = json['hasMasterPin'] ?? false;
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    firstName = json['firstName'] ?? '';
    lastName = json['lastName'] ?? '';
    nickname = json['nickname'] ?? '';
    googleId = json['googleId'] ?? '';
    facebookId = json['facebookId'] ?? '';
    if(json['attributes'] != null){
      final map = json['attributes'] as Map<String, dynamic>;
      map.forEach((key, value) {
        attributes[key] = value as String;
      });
    }
    avatar = json['avatar'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['hasMasterPin'] = hasMasterPin;
    data['username'] = username;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['nickname'] = nickname;
    data['googleId'] = googleId;
    data['facebookId'] = facebookId;
    data['attributes'] = attributes;
    data['avatar'] = avatar;
    return data;
  }

  String getFullName(){
    var name = '';
    if(firstName.isNotEmpty && lastName.isNotEmpty){
      name = '$firstName $lastName';
    } else {
      name = username;
    }

    return name;
  }

}