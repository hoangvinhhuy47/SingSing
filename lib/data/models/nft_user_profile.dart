class NftUserProfile {
  late bool emailVerified;
  late bool verified;
  late String cover;
  late String avatar;
  late String lastName;
  late String firstName;
  late String name;
  late String username;
  late String email;
  late String ssUserId;
  late String userId;

  NftUserProfile(
      {required this.emailVerified,
        required this.verified,
        required this.cover,
        required this.avatar,
        required this.lastName,
        required this.firstName,
        required this.name,
        required this.username,
        required this.email,
        required this.ssUserId,
        required this.userId});

  NftUserProfile.fromJson(Map<String, dynamic> json) {
    emailVerified = json['email_verified'] ?? false;
    verified = json['verified'] ?? false;
    cover = json['cover'] ?? '';
    avatar = json['avatar'] ?? '';
    lastName = json['last_name'] ?? '';
    firstName = json['first_name'] ?? '';
    name = json['name'] ?? '';
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    ssUserId = json['ss_user_id'] ?? '';
    userId = json['user_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data =  <String, dynamic>{};
    data['email_verified'] = emailVerified;
    data['verified'] = verified;
    data['cover'] = cover;
    data['avatar'] = avatar;
    data['last_name'] = lastName;
    data['first_name'] = firstName;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['ss_user_id'] = ssUserId;
    data['user_id'] = userId;
    return data;
  }

}