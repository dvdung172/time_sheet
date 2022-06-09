// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseError _$BaseErrorFromJson(Map<String, dynamic> json) => BaseError(
      key: json['key'] as String?,
      message: json['message'] as String?,
      params: json['params'] as String?,
    );

Map<String, dynamic> _$BaseErrorToJson(BaseError instance) => <String, dynamic>{
      'key': instance.key,
      'message': instance.message,
      'params': instance.params,
    };
