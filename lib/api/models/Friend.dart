class Friend {
  final String email;
  final String name;
  final String displayName;
  final String profileImageUrl;
  final String statusMessage;

  const Friend(this.name, this.email, this.profileImageUrl, this.statusMessage,
      this.displayName);

  Friend.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        profileImageUrl = json['profilImage'],
        email = json['email'],
        displayName = json['displayName'],
        statusMessage = json['statusMessage'];
}
