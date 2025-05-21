import 'package:equatable/equatable.dart';
import '../../../data/models/album.dart';

/// Base class for all album-related states
abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any album data is loaded
class AlbumInitial extends AlbumState {}

/// State when albums are being loaded
class AlbumLoading extends AlbumState {}

/// State when albums have been successfully loaded
class AlbumLoaded extends AlbumState {
  /// The list of loaded albums
  final List<Album> albums;

  const AlbumLoaded(this.albums);

  @override
  List<Object?> get props => [albums];
}

/// State when a single album has been successfully loaded
class SingleAlbumLoaded extends AlbumState {
  /// The loaded album
  final Album album;

  const SingleAlbumLoaded(this.album);

  @override
  List<Object?> get props => [album];
}

/// State when an error occurs while loading albums
class AlbumError extends AlbumState {
  /// The error message
  final String message;

  const AlbumError(this.message);

  @override
  List<Object?> get props => [message];
}