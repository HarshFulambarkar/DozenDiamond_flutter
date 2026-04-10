// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dozen_diamond/global/models/api_request_response.dart';

class FetchRunIdResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Data? data;

  FetchRunIdResponse({this.status, this.message, this.data});

  FetchRunIdResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data implements ApiRequestResponse {
  List<RecentRun>? recentRun;
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Data({this.recentRun, this.total, this.page, this.limit, this.totalPages});

  Data fromJson(Map<String, dynamic> json) {
    if (json['recent_run'] != null) {
      recentRun = <RecentRun>[];
      json['recent_run'].forEach((v) {
        recentRun!.add(new RecentRun().fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recentRun != null) {
      data['recent_run'] = this.recentRun!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class RecentRun implements ApiRequestResponse {
  int? runId;
  String? createdAt;
  String? updatedAt;
  int? ladderCount;

  RecentRun({this.runId, this.createdAt, this.updatedAt, this.ladderCount});

  RecentRun fromJson(Map<String, dynamic> json) {
    runId = json['run_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ladderCount = json['ladder_count'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['run_id'] = this.runId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['ladder_count'] = this.ladderCount;
    return data;
  }
}