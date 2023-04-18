class RegisterRespon {
  int? id;
  String? token;

  RegisterRespon({this.id, this.token});

  RegisterRespon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    return data;
  }
}

class RegisterBegin extends RegisterRespon{}
class RegisterLoading extends RegisterRespon{}
class RegisterError extends RegisterRespon{}