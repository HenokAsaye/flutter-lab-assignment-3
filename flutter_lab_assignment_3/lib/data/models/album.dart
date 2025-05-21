import 'package:equatable/equatable.dart';

/// Represents an album with its associated photo information from the JSONPlaceholder API.
/// 
/// This model combines both album and photo information for simplified data handling.
class Album extends Equatable {
  /// The ID of the album this photo belongs to
  final int albumId;

  /// The unique identifier of the photo
  final int id;

  /// The title of the photo
  final String title;

  /// The URL of the full-size photo
  final String url;

  /// The URL of the photo thumbnail
  final String thumbnailUrl;

  /// Creates an [Album] instance.
  /// 
  /// All parameters are required and must not be null.
  const Album({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  /// Creates an [Album] instance from a JSON map.
  /// 
  /// Throws a [FormatException] if any required field is missing or has an invalid type.
  factory Album.fromJson(Map<String, dynamic> json) {
    try {
      return Album(
        albumId: json['albumId'] as int,
        id: json['id'] as int,
        title: json['title'] as String,
        url: json['url'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
      );
    } catch (e) {
      throw FormatException(
        'Failed to create Album from JSON: $json\nError: $e',
      );
    }
  }

  /// Converts this [Album] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  /// Creates a copy of this [Album] instance with the given fields replaced with new values.
  Album copyWith({
    int? albumId,
    int? id,
    String? title,
    String? url,
    String? thumbnailUrl,
  }) {
    return Album(
      albumId: albumId ?? this.albumId,
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  List<Object?> get props => [albumId, id, title, url, thumbnailUrl];

  @override
  String toString() {
    return 'Album{albumId: $albumId, id: $id, title: $title}';
  }
} 