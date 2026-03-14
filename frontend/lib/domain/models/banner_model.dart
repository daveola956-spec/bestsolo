import 'package:equatable/equatable.dart';

class BannerModel extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String? link;
  final bool active;
  final DateTime createdAt;

  const BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.link,
    required this.active,
    required this.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String,
      link: json['link'] as String?,
      active: json['active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image_url': imageUrl,
    'link': link,
    'active': active,
    'created_at': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, title, imageUrl, link, active, createdAt];
}
