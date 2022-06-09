import 'package:json_annotation/json_annotation.dart';

import 'base_error.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  /// 0: success, other: error
  int? status;
  List<BaseError>? errors;
  T? data;

  BaseResponse({this.status, this.errors, this.data});
  BaseResponse.success(T? data) : this(status: 0, data: data);
  // BaseResponse.fail(List<BaseError>? errors) : this(status: -1, errors: errors);
  BaseResponse.fail(List<String>? messages)
      : this(
          status: -1,
          errors: messages?.map((e) => BaseError(message: e)).toList(),
        );

  factory BaseResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseResponseFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);

  @override
  String toString() => '{status: $status, data: $data, errors: $errors}';
}
