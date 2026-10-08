import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/constants/app_assets.dart';
import 'core/theme/app_text.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(AppAssets.fontLicense);
    yield LicenseEntryWithLineBreaks([AppText.fontFamily], license);
  });
  runApp(const TheoryProgressApp());
}
