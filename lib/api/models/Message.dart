class Message {
  final int messid;
  final String sender;
  final String message;

  Message(this.messid, this.sender, this.message);

  Message.fromJson(Map<String, dynamic> json)
      : messid = json['messid'],
        sender = json['sender'],
        message = json['message'];

/*  Map<String, dynamic> toJson() => {
    'userName': userName,
    'email': email,
  };*/

}
