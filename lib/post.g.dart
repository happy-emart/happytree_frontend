// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int,
      statement: json['statement'] as String,
      thanks: json['thanks'] as String,
      writer: json['writer'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'statement': instance.statement,
      'thanks': instance.thanks,
      'writer': instance.writer,
    };
