class UserGeneral {
  final String email;
  final String name;
  final String displayName;
  final String profileImageUrl;
  final String statusMessage;

  const UserGeneral(this.name, this.email, this.profileImageUrl,
      this.statusMessage, this.displayName);

  UserGeneral.fromJson(Map<String, dynamic> json)
      : name = json['userName'],
        profileImageUrl = json['profilePicUrl'],
        email = json['email'],
        displayName = json['displayName'],
        statusMessage = json['statusMessage'];
}
