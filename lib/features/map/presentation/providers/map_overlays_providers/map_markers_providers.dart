import 'package:fpdart/fpdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shipper/features/map/presentation/providers/my_location_providers/my_location_marker_provider.dart';
import 'package:shipper/features/map/presentation/providers/target_location_providers/target_location_marker_provider.dart';

final mapMarkersProvider =
    NotifierProvider.autoDispose<MapMarkersNotifier, Set<Marker>>(
        MapMarkersNotifier.new);

class MapMarkersNotifier extends AutoDisposeNotifier<Set<Marker>> {
  @override
  Set<Marker> build() {
    state = {};
    ref.listen<Option<Marker>>(
      myLocationMarkerProvider,
      (previous, next) {
        next.fold(
          () {},
          (marker) {
            _addMarker(marker);
          },
        );
      },
      fireImmediately: true,
    );
    ref.listen<Marker>(
      targetLocationMarkerProvider,
      (previous, next) {
        _addMarker(next);
      },
      fireImmediately: true,
    );
    return state;
  }

  _addMarker(Marker marker) {
    final Set<Marker> mapMarkers = Set.from(state);

    /// If mapMarkers already has marker with same id, remove it first to avoid adding duplicate markers and replace it instead.
    mapMarkers.removeWhere((m) => m.markerId == marker.markerId);
    mapMarkers.add(marker);

    state = mapMarkers;
  }
}
