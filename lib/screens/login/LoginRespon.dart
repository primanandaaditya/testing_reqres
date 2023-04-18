class LoginRespon {
  String? token;

  LoginRespon({this.token});

  LoginRespon.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}

class LoginBegin extends LoginRespon{}
class LoginLoading extends LoginRespon{}
class LoginError extends LoginRespon{}