@Timeout(Duration(milliseconds: 500))

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/app.dart';

import '../robot.dart';

void main() {
  final sizeVariant = ValueVariant<Size>({
    const Size(300, 600),
    const Size(600, 800),
    const Size(1000, 1000),
  });
  testWidgets(
    'Golden - workspace list',
    (tester) async {
      final r = Robot(tester);
      final currentSize = sizeVariant.currentValue!;
      await r.golden.setSurfaceSize(currentSize);
      await r.golden.loadRobotoFont();
      await r.golden.loadMaterialIconFont();
      await r.pumpMyApp(startSignedIn: true);
      await r.golden.precacheImages();
      final currentSizeString =
          '${currentSize.width.toInt()}x${currentSize.height.toInt()}';
      await expectLater(
        find.byType(MyApp),
        matchesGoldenFile('workspace_list_$currentSizeString.png'),
      );
    },
    variant: sizeVariant,
    tags: ['golden'],
  );
}
