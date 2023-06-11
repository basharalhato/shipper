import 'dart:async';

import 'package:shipper/features/map/domain/entities/place_autocomplete.dart';
import 'package:shipper/features/map/domain/entities/place_details.dart';
import 'package:shipper/features/map/domain/entities/place_directions.dart';
import 'package:shipper/features/map/domain/use_cases/get_place_autocomplete_uc.dart';
import 'package:shipper/features/map/domain/use_cases/get_place_details_uc.dart';
import 'package:shipper/features/map/domain/use_cases/get_place_directions_uc.dart';

abstract class IMapRepo {
  Future<List<PlaceAutocomplete>> getPlaceAutocomplete(
      GetPlaceAutocompleteParams params);

  Future<PlaceDetails> getPlaceDetails(GetPlaceDetailsParams params);

  Future<PlaceDirections> getPlaceDirections(GetPlaceDirectionsParams params);
}
