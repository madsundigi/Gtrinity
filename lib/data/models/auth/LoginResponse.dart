class LoginResponse {
  final bool? success;
  final String? message;
  final LoginData? data;

  LoginResponse({
    this.success,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class LoginData {
  final String? token;
  final User? user;

  LoginData({
    this.token,
    this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "user": user?.toJson(),
    };
  }
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? type;
  final String? profile;
  final String? phoneNumber;
  final String? lang;
  final int? isActive;
  final List<Role>? roles;
  final Guard? guards;

  User({
    this.id,
    this.name,
    this.email,
    this.type,
    this.profile,
    this.phoneNumber,
    this.lang,
    this.isActive,
    this.roles,
    this.guards,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      type: json['type'],
      profile: json['profile'],
      phoneNumber: json['phone_number'],
      lang: json['lang'],
      isActive: json['is_active'],
      roles: json['roles'] != null
          ? (json['roles'] as List).map((e) => Role.fromJson(e)).toList()
          : [],
      guards:
      json['guards'] != null ? Guard.fromJson(json['guards']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "type": type,
      "profile": profile,
      "phone_number": phoneNumber,
      "lang": lang,
      "is_active": isActive,
      "roles": roles?.map((e) => e.toJson()).toList(),
      "guards": guards?.toJson(),
    };
  }
}

class Role {
  final int? id;
  final String? name;
  final Pivot? pivot;

  Role({
    this.id,
    this.name,
    this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "pivot": pivot?.toJson(),
    };
  }
}

class Pivot {
  final int? modelId;
  final int? roleId;
  final String? modelType;

  Pivot({
    this.modelId,
    this.roleId,
    this.modelType,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      modelId: json['model_id'],
      roleId: json['role_id'],
      modelType: json['model_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "model_id": modelId,
      "role_id": roleId,
      "model_type": modelType,
    };
  }
}

class Guard {
  final int? id;
  final int? userId;
  final String? gender;
  final String? city;
  final String? state;
  final String? country;
  final String? address;
  final int? payPerHour;

  Guard({
    this.id,
    this.userId,
    this.gender,
    this.city,
    this.state,
    this.country,
    this.address,
    this.payPerHour,
  });

  factory Guard.fromJson(Map<String, dynamic> json) {
    return Guard(
      id: json['id'],
      userId: json['user_id'],
      gender: json['gender'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      address: json['address'],
      payPerHour: json['pay_per_hour'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "gender": gender,
      "city": city,
      "state": state,
      "country": country,
      "address": address,
      "pay_per_hour": payPerHour,
    };
  }
}