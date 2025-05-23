import '../datasources/album_remote_datasource.dart';
import '../models/album.dart';

/// Abstract class defining the contract for album-related operations.
abstract class IAlbumRepository {
  /// Fetches a list of albums from the remote data source.
  ///
  /// If [forceRefresh] is true, it will fetch fresh data from the remote source,
  /// otherwise it might return cached data if available.
  Future<List<Album>> getAlbums({bool forceRefresh});

  /// Fetches a specific album by its ID.
  ///
  /// First tries to find the album in the cache, if not found,
  /// fetches it from the remote data source.
  Future<Album> getAlbumById(int id);

  /// Clears any cached data.
  void clearCache();

  /// Releases any resources held by the repository.
  void dispose();
}

/// Implementation of [IAlbumRepository] that handles album-related operations
/// with caching support.
class AlbumRepository implements IAlbumRepository {
  final AlbumRemoteDataSource _remoteDataSource;
  List<Album>? _cachedAlbums;
  bool _isFetching = false;

  /// Creates an instance of [AlbumRepository].
  ///
  /// If [remoteDataSource] is not provided, creates a default implementation.
  AlbumRepository({
    AlbumRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? AlbumRemoteDataSourceImpl();

  @override
  Future<List<Album>> getAlbums({bool forceRefresh = false}) async {
    // Return cached data if available and not forcing refresh
    if (!forceRefresh && _cachedAlbums != null) {
      return _cachedAlbums!;
    }

    // Prevent multiple simultaneous fetches
    if (_isFetching) {
      throw Exception('Already fetching albums');
    }

    _isFetching = true;

    try {
      final response = await _remoteDataSource.getAlbums();
      
      if (response.isSuccess) {
        _cachedAlbums = response.data;
        return response.data;
      } else {
        throw Exception(response.error ?? 'Failed to fetch albums');
      }
    } finally {
      _isFetching = false;
    }
  }

  @override
  Future<Album> getAlbumById(int id) async {
    // First, try to find the album in the cache
    if (_cachedAlbums != null) {
      final cachedAlbum = _cachedAlbums!.firstWhere(
        (album) => album.id == id,
        orElse: () => throw Exception('Album not found in cache'),
      );
      return cachedAlbum;
    }

    // If not in cache or cache is empty, fetch from remote
    final response = await _remoteDataSource.getAlbumById(id);
    
    if (response.isSuccess) {
      return response.data;
    } else {
      throw Exception(response.error ?? 'Failed to fetch album');
    }
  }

  @override
  void clearCache() {
    _cachedAlbums = null;
  }

  @override
  void dispose() {
    clearCache();
    _remoteDataSource.dispose();
  }

  /// Returns whether there is cached data available.
  bool get hasCachedData => _cachedAlbums != null;

  /// Returns whether the repository is currently fetching data.
  bool get isFetching => _isFetching;
}