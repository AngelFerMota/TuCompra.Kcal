import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cestaria/core/services/mercadona_api.dart';
import 'package:cestaria/core/services/openfoodfacts_api.dart';
import 'package:cestaria/core/services/local_database.dart';
import 'package:cestaria/core/services/nfc_service.dart';

final mercadonaApiProvider = Provider<MercadonaApi>((ref) => MercadonaApi());
final openFoodFactsApiProvider = Provider<OpenFoodFactsApi>((ref) => OpenFoodFactsApi());
final localDatabaseProvider = Provider<LocalDatabase>((ref) => LocalDatabase());
final nfcServiceProvider = Provider<NfcService>((ref) => NfcService());
