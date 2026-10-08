import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/constants/app_assets.dart';
import 'core/config/app_config.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_text.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(AppConfig.fromEnvironment());
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(AppAssets.fontLicense);
    yield LicenseEntryWithLineBreaks([AppText.fontFamily], license);
  });
  runApp(const TheoryProgressApp());
}
