import 'package:equatable/equatable.dart';

/// Base class for all album-related events
abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all albums
class LoadAlbums extends AlbumEvent {
  /// Whether to force a refresh from the remote source
  final bool forceRefresh;

  const LoadAlbums({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

/// Event to load a specific album by ID
class LoadAlbumById extends AlbumEvent {
  /// The ID of the album to load
  final int id;

  const LoadAlbumById(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to clear the album cache
class ClearAlbumCache extends AlbumEvent {}