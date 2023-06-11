import 'package:shipper/core/core_features/theme/data/data_sources/theme_local_data_source.dart';
import 'package:shipper/core/core_features/theme/domain/repos/i_theme_repo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themeRepoProvider = Provider<IThemeRepo>(
  (ref) => ThemeRepo(
    localDataSource: ref.watch(themeLocalDataSourceProvider),
  ),
);

class ThemeRepo implements IThemeRepo {
  ThemeRepo({required this.localDataSource});

  final IThemeLocalDataSource localDataSource;

  @override
  Future<String> getAppTheme() async {
    final theme = await localDataSource.getAppTheme();
    return theme;
  }

  @override
  Future<void> cacheAppTheme(String themeString) async {
    await localDataSource.cacheAppTheme(themeString);
  }
}
