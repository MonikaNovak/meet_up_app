class Friend {
  final String email;
  final String name;
  final String profileImageUrl;
  final String status;

  const Friend(this.name, this.email, this.profileImageUrl, this.status);

  Friend.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        profileImageUrl = json['picture']['large'],
        email = json['email'],
        status = json['status'];
}
