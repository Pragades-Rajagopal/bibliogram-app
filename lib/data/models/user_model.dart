class Login {
  String? username;
  String? privateKey;
}

class LoginResponse {
  int? statusCode;
  String? message;
  String? token;

  LoginResponse({
    this.statusCode,
    this.message,
    this.token,
  });

  LoginResponse.fromJSON(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
    token = json["token"];
  }
}

class Register {
  String? username;
  String? fullname;
}

class RegistrationResponse {
  int? statusCode;
  String? message;
  String? privateKey;

  RegistrationResponse({
    this.statusCode,
    this.message,
    this.privateKey,
  });

  RegistrationResponse.fromJSON(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
    privateKey = json["privateKey"];
  }
}

class LogoutResponse {
  int? statusCode;
  String? message;
  String? error;

  LogoutResponse({
    this.statusCode,
    this.message,
    this.error,
  });

  LogoutResponse.fromJSON(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
    error = json["error"];
  }
}
