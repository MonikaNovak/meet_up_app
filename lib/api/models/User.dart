class User {
  final String id;
  final String userName;
  final String email;
  final String avatarUrl;
  final String status;
  final messages;

  User(this.id, this.userName, this.email, this.avatarUrl, this.status,
      this.messages);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userName = json['userName'],
        email = json['email'],
        avatarUrl = json['avatar'],
        status = json['status'],
        messages = json['messages'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
      };

  String getUserName() {
    return userName;
  }
}
