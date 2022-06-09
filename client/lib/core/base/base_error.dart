import 'package:json_annotation/json_annotation.dart';

part 'base_error.g.dart';

@JsonSerializable()
class BaseError {
  String? key;
  String? message;
  String? params;

  BaseError({
    this.key,
    this.message,
    this.params,
  });

  factory BaseError.fromJson(Map<String, dynamic> json) =>
      _$BaseErrorFromJson(json);
  Map<String, dynamic> toJson() => _$BaseErrorToJson(this);

  @override
  String toString() => '{message: $message, key: $key, params: $params}';
}
