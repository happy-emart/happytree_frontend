import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int id;
  String statement;
  String thanks;
  String writer;

  Post({
    required this.id,
    required this.statement,
    required this.thanks,
    required this.writer
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

  // Specify that these fields should not be included in JSON serialization
  @JsonKey(includeToJson: false, includeFromJson: false) // What is the meaning of these??
  dynamic ignoreThisField;

}
