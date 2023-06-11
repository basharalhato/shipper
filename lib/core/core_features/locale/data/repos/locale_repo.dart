import 'package:shipper/core/core_features/locale/data/data_sources/locale_local_data_source.dart';
import 'package:shipper/core/core_features/locale/domain/repos/i_locale_repo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final localeRepoProvider = Provider<ILocaleRepo>(
  (ref) => LocaleRepo(
    localDataSource: ref.watch(localeLocalDataSourceProvider),
  ),
);

class LocaleRepo implements ILocaleRepo {
  LocaleRepo({required this.localDataSource});

  final ILocaleLocalDataSource localDataSource;

  @override
  Future<String> getAppLocale() async {
    final locale = await localDataSource.getAppLocale();
    return locale;
  }

  @override
  Future<void> cacheAppLocale(String languageCode) async {
    await localDataSource.cacheAppLocale(languageCode);
  }
}
