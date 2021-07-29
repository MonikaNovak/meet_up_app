class Token {
  final String token;

  Token({required this.token});

/*  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
    );
  }*/

  factory Token.fromJson(Map<String, dynamic> json) {
    print('FEEDBACK - running Token.fromJson');
    return Token(
      token: json['jwtToken'],
    );
  }
  //Token.fromJson(Map<String, dynamic> json) : token = json['jwtToken'];
}
