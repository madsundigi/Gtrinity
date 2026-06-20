class DashboardResponse {
  final bool? success;
  final DashboardData? data;

  DashboardResponse({this.success, this.data});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json['success'],
      data: json['data'] != null ? DashboardData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class DashboardData {
  final TodayDuty? todayDuty;
  final dynamic attendanceToday;
  final int? pendingLeavesCount;
  final List<Notice>? latestNotices;

  DashboardData({
    this.todayDuty,
    this.attendanceToday,
    this.pendingLeavesCount,
    this.latestNotices,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    try {
      return DashboardData(
        todayDuty: json['today_duty'] != null
            ? TodayDuty.fromJson(json['today_duty'] as Map<String, dynamic>)
            : null,
        attendanceToday: json['attendance_today'],
        pendingLeavesCount: json['pending_leaves_count'] is int
            ? json['pending_leaves_count']
            : int.tryParse(json['pending_leaves_count']?.toString() ?? '0'),
        latestNotices: json['latest_notices'] != null
            ? (json['latest_notices'] as List)
                .map((v) => Notice.fromJson(v))
                .toList()
            : null,
      );
    } catch (e, st) {
      print('DEBUG DashboardData.fromJson ERROR: $e');
      print('DEBUG StackTrace: $st');
      return DashboardData();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'today_duty': todayDuty?.toJson(),
      'attendance_today': attendanceToday,
      'pending_leaves_count': pendingLeavesCount,
      'latest_notices': latestNotices?.map((v) => v.toJson()).toList(),
    };
  }
}

class TodayDuty {
  final int? id;
  final int? guardId;
  final String? startDate;
  final String? endDate;
  final int? client;
  final int? location;
  final int? dutyTime;
  final String? notes;
  final int? parentId;
  final String? createdAt;
  final String? updatedAt;
  final ClientDetails? clients;
  final LocationDetails? locationes;
  final DutyDetails? dutys;
  final String? status; // pending / accepted / rejected

  TodayDuty({
    this.status,
    this.id,
    this.guardId,
    this.startDate,
    this.endDate,
    this.client,
    this.location,
    this.dutyTime,
    this.notes,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.clients,
    this.locationes,
    this.dutys,
  });

  factory TodayDuty.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return TodayDuty(
      id: _parseInt(json['id']),
      guardId: _parseInt(json['guard_id']),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      client: _parseInt(json['client']),
      location: _parseInt(json['location']),
      dutyTime: _parseInt(json['duty_time']),
      notes: json['notes']?.toString(),
      parentId: _parseInt(json['parent_id']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      clients: json['clients'] != null ? ClientDetails.fromJson(json['clients']) : null,
      locationes: json['locationes'] != null ? LocationDetails.fromJson(json['locationes']) : null,
      dutys: json['dutys'] != null ? DutyDetails.fromJson(json['dutys']) : null,
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guard_id': guardId,
      'start_date': startDate,
      'end_date': endDate,
      'client': client,
      'location': location,
      'duty_time': dutyTime,
      'notes': notes,
      'parent_id': parentId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'clients': clients?.toJson(),
      'locationes': locationes?.toJson(),
      'dutys': dutys?.toJson(),
      'status': status,
    };
  }
}

class ClientDetails {
  final int? id;
  final String? name;
  final String? email;
  final String? type;
  final String? profile;
  final String? phoneNumber;
  final String? lang;
  final dynamic subscription;
  final dynamic subscriptionExpireDate;
  final int? parentId;
  final String? emailVerifiedAt;
  final dynamic emailVerificationToken;
  final dynamic twofaSecret;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;

  ClientDetails({
    this.id,
    this.name,
    this.email,
    this.type,
    this.profile,
    this.phoneNumber,
    this.lang,
    this.subscription,
    this.subscriptionExpireDate,
    this.parentId,
    this.emailVerifiedAt,
    this.emailVerificationToken,
    this.twofaSecret,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ClientDetails.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return ClientDetails(
      id: _parseInt(json['id']),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      type: json['type']?.toString(),
      profile: json['profile']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      lang: json['lang']?.toString(),
      subscription: json['subscription'],
      subscriptionExpireDate: json['subscription_expire_date']?.toString(),
      parentId: _parseInt(json['parent_id']),
      emailVerifiedAt: json['email_verified_at']?.toString(),
      emailVerificationToken: json['email_verification_token'],
      twofaSecret: json['twofa_secret'],
      isActive: _parseInt(json['is_active']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'type': type,
      'profile': profile,
      'phone_number': phoneNumber,
      'lang': lang,
      'subscription': subscription,
      'subscription_expire_date': subscriptionExpireDate,
      'parent_id': parentId,
      'email_verified_at': emailVerifiedAt,
      'email_verification_token': emailVerificationToken,
      'twofa_secret': twofaSecret,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class LocationDetails {
  final int? id;
  final int? clientId;
  final String? siteName;
  final String? location;
  final String? siteInstruction;
  final int? parentId;
  final String? createdAt;
  final String? updatedAt;

  LocationDetails({
    this.id,
    this.clientId,
    this.siteName,
    this.location,
    this.siteInstruction,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return LocationDetails(
      id: _parseInt(json['id']),
      clientId: _parseInt(json['client_id']),
      siteName: json['site_name']?.toString(),
      location: json['location']?.toString(),
      siteInstruction: json['site_instruction']?.toString(),
      parentId: _parseInt(json['parent_id']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'site_name': siteName,
      'location': location,
      'site_instruction': siteInstruction,
      'parent_id': parentId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class DutyDetails {
  final int? id;
  final String? title;
  final String? company;
  final int? averageHourPerDay;
  final String? notes;
  final int? parentId;
  final String? createdAt;
  final String? updatedAt;

  DutyDetails({
    this.id,
    this.title,
    this.company,
    this.averageHourPerDay,
    this.notes,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  factory DutyDetails.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return DutyDetails(
      id: _parseInt(json['id']),
      title: json['title']?.toString(),
      company: json['company']?.toString(),
      averageHourPerDay: _parseInt(json['average_hour_per_day']),
      notes: json['notes']?.toString(),
      parentId: _parseInt(json['parent_id']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'average_hour_per_day': averageHourPerDay,
      'notes': notes,
      'parent_id': parentId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Notice {
  final int? id;
  final String? title;
  final String? description;
  final String? attachment;
  final int? parentId;
  final String? createdAt;
  final String? updatedAt;

  Notice({
    this.id,
    this.title,
    this.description,
    this.attachment,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return Notice(
      id: _parseInt(json['id']),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      attachment: json['attachment']?.toString(),
      parentId: _parseInt(json['parent_id']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'attachment': attachment,
      'parent_id': parentId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
