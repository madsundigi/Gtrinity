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
  // Admin-controlled (read-only in the app)
  final int? guardId;
  final dynamic guardType;
  final String? joinDate;
  final int? payPerHour;
  // Guard-editable personal detail
  final String? gender;
  final String? dob;
  final String? language;
  final String? height;
  final String? weight;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String? address;
  // Mandatory + driving documents (file name on server) + expiry
  final String? securityLicense;
  final String? securityLicenseExpire;
  final String? firstAid;
  final String? firstAidExpire;
  final String? rsa;
  final String? rsaExpire;
  final String? drivingLicense;
  final String? dlNumber;
  final String? dlExpireDate;
  // Onboarding lifecycle + guard-entered client + admin correction flags
  final String? onboardingStatus; // pending | completed
  final int? clientId;
  final String? clientName;
  final Map<String, String> fieldFlags; // field -> admin remark

  Guard({
    this.id,
    this.userId,
    this.guardId,
    this.guardType,
    this.joinDate,
    this.payPerHour,
    this.gender,
    this.dob,
    this.language,
    this.height,
    this.weight,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.address,
    this.securityLicense,
    this.securityLicenseExpire,
    this.firstAid,
    this.firstAidExpire,
    this.rsa,
    this.rsaExpire,
    this.drivingLicense,
    this.dlNumber,
    this.dlExpireDate,
    this.onboardingStatus,
    this.clientId,
    this.clientName,
    this.fieldFlags = const {},
  });

  bool get isOnboardingComplete => onboardingStatus == 'completed';

  /// field_flags can arrive as a JSON object, a JSON string, or null.
  static Map<String, String> _flags(dynamic v) {
    if (v is Map) {
      return v.map((k, val) => MapEntry(k.toString(), val?.toString() ?? ''));
    }
    return const {};
  }

  /// Coerces numeric-or-string JSON values to a trimmed String? (height/weight
  /// arrive as numbers from the API but display as text).
  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  factory Guard.fromJson(Map<String, dynamic> json) {
    return Guard(
      id: json['id'],
      userId: json['user_id'],
      guardId: json['guard_id'],
      guardType: json['guard_type'],
      joinDate: _str(json['join_date']),
      payPerHour: json['pay_per_hour'],
      gender: json['gender'],
      dob: _str(json['dob']),
      language: json['language'],
      height: _str(json['height']),
      weight: _str(json['weight']),
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zipCode: _str(json['zip_code']),
      address: json['address'],
      securityLicense: json['security_license'],
      securityLicenseExpire: _str(json['security_license_expire']),
      firstAid: json['first_aid'],
      firstAidExpire: _str(json['first_aid_expire']),
      rsa: json['rsa'],
      rsaExpire: _str(json['rsa_expire']),
      drivingLicense: json['driving_license'],
      dlNumber: _str(json['dl_number']),
      dlExpireDate: _str(json['dl_expire_date']),
      onboardingStatus: json['onboarding_status'],
      clientId: json['client_id'] is int
          ? json['client_id']
          : int.tryParse('${json['client_id'] ?? ''}'),
      clientName: json['client_name'],
      fieldFlags: _flags(json['field_flags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "guard_id": guardId,
      "guard_type": guardType,
      "join_date": joinDate,
      "pay_per_hour": payPerHour,
      "gender": gender,
      "dob": dob,
      "language": language,
      "height": height,
      "weight": weight,
      "city": city,
      "state": state,
      "country": country,
      "zip_code": zipCode,
      "address": address,
      "security_license": securityLicense,
      "security_license_expire": securityLicenseExpire,
      "first_aid": firstAid,
      "first_aid_expire": firstAidExpire,
      "rsa": rsa,
      "rsa_expire": rsaExpire,
      "driving_license": drivingLicense,
      "dl_number": dlNumber,
      "dl_expire_date": dlExpireDate,
      "onboarding_status": onboardingStatus,
      "client_id": clientId,
      "client_name": clientName,
      "field_flags": fieldFlags,
    };
  }
}