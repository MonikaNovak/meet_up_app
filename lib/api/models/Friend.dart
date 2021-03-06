class Friend {
  final String email;
  final String name;
  final String displayName;
  final String profileImageUrl;
  final String statusMessage;
  final int status;

  const Friend(this.name, this.email, this.profileImageUrl, this.statusMessage,
      this.displayName, this.status);

  Friend.fromJsonLocal(Map<String, dynamic> json)
      : name = json['name'],
        profileImageUrl = json['profilImage'],
        email = json['email'],
        displayName = json['displayName'],
        statusMessage = json['statusMessage'],
        status = json['status'];

  Friend.fromJson(Map<String, dynamic> json) // TODO correct data?
      : name = json['userName'],
        profileImageUrl = json['profilePicUrl'],
        email = json['email'],
        displayName = json['displayName'],
        statusMessage = json['statusMessage'],
        status = json['status'];
}
