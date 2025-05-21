import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/album_repository.dart';
import 'events/album_events.dart';
import 'states/album_state.dart';

/// BLoC that handles album-related business logic
class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final IAlbumRepository repository;

  AlbumBloc({
    required this.repository,
  }) : super(AlbumInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<LoadAlbumById>(_onLoadAlbumById);
    on<ClearAlbumCache>(_onClearCache);
  }

  /// Handles the [LoadAlbums] event
  Future<void> _onLoadAlbums(
    LoadAlbums event,
    Emitter<AlbumState> emit,
  ) async {
    emit(AlbumLoading());
    
    try {
      final albums = await repository.getAlbums(
        forceRefresh: event.forceRefresh,
      );
      emit(AlbumLoaded(albums));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }

  /// Handles the [LoadAlbumById] event
  Future<void> _onLoadAlbumById(
    LoadAlbumById event,
    Emitter<AlbumState> emit,
  ) async {
    emit(AlbumLoading());
    
    try {
      final album = await repository.getAlbumById(event.id);
      emit(SingleAlbumLoaded(album));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }

  /// Handles the [ClearAlbumCache] event
  void _onClearCache(
    ClearAlbumCache event,
    Emitter<AlbumState> emit,
  ) {
    repository.clearCache();
    emit(AlbumInitial());
  }

  @override
  Future<void> close() {
    repository.dispose();
    return super.close();
  }
}