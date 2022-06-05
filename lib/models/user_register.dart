class UserRegister {
  final String email;
  final String username;
  final String password;
  final String confirm;

  UserRegister(this.email, this.username, this.password, this.confirm);

  Map<String, String> toJson() => {
        'email': email.trim(),
        'username': username.trim(),
        'password': password.trim(),
        'confirm': confirm.trim()
      };
}
