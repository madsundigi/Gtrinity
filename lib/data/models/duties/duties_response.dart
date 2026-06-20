import 'package:chef_king/data/models/home/dashboard_response.dart';

class DutiesResponse {
  final bool? success;
  final DutiesData? data;

  DutiesResponse({this.success, this.data});

  factory DutiesResponse.fromJson(Map<String, dynamic> json) {
    return DutiesResponse(
      success: json['success'],
      data: json['data'] != null ? DutiesData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class DutiesData {
  final int? currentPage;
  final List<TodayDuty>? data;
  final int? total;
  final int? lastPage;
  final int? perPage;

  DutiesData({
    this.currentPage,
    this.data,
    this.total,
    this.lastPage,
    this.perPage,
  });

  factory DutiesData.fromJson(Map<String, dynamic> json) {
    return DutiesData(
      currentPage: json['current_page'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => TodayDuty.fromJson(i)).toList()
          : null,
      total: json['total'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data?.map((i) => i.toJson()).toList(),
      'total': total,
      'last_page': lastPage,
      'per_page': perPage,
    };
  }
}
