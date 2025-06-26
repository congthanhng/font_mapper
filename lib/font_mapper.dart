library font_mapper;

import 'dart:io';

/// Run the font mapper to update the fonts section in a pubspec.yaml file.
void runFontMapper({String targetPath = 'pubspec.yaml', String fontsDirPath = 'assets/fonts'}) {
  final fontsDir = Directory(fontsDirPath);
  if (!fontsDir.existsSync()) {
    print('❌ Font directory not found: $fontsDirPath');
    return;
  }

  final fontsMap = <String, List<Map<String, dynamic>>>{};
  final weightMap = {
    'thin': 100,
    'extralight': 200,
    'ultralight': 200,
    'light': 300,
    'regular': 400,
    'normal': 400,
    'medium': 500,
    'semibold': 600,
    'demibold': 600,
    'bold': 700,
    'extrabold': 800,
    'ultrabold': 800,
    'heavy': 800,
    'black': 900,
  };

  // Scan font files
  for (var file in fontsDir.listSync(recursive: true)) {
    if (file is File && (file.path.endsWith('.ttf') || file.path.endsWith('.otf'))) {
      final filename = file.uri.pathSegments.last.replaceAll('.ttf', '').replaceAll('.otf', '');
      final parts = filename.split('-');
      if (parts.length < 2) continue;

      final family = parts.sublist(0, parts.length - 1).join('-');
      final stylePart = parts.last.toLowerCase();
      final style = stylePart.contains('italic') ? 'italic' : 'normal';

      int? weight;
      for (var key in weightMap.keys) {
        if (stylePart.contains(key)) {
          weight = weightMap[key];
          break;
        }
      }

      fontsMap.putIfAbsent(family, () => []).add({
        'asset': file.path.replaceAll('\\', '/'),
        'weight': weight,
        'style': style,
      });
    }
  }

  // Build the YAML fonts block
  final fontBlock = StringBuffer('  fonts:\n');
  for (var family in fontsMap.entries) {
    fontBlock.writeln('    - family: ${family.key}');
    fontBlock.writeln('      fonts:');
    for (var font in family.value) {
      fontBlock.write('        - asset: ${font['asset']}');
      if (font['weight'] != null) fontBlock.write('\n          weight: ${font['weight']}');
      if (font['style'] == 'italic') fontBlock.write('\n          style: italic');
      fontBlock.writeln();
    }
  }

  // Load target pubspec.yaml
  final targetFile = File(targetPath);
  if (!targetFile.existsSync()) {
    print('❌ Target file not found: $targetPath');
    return;
  }

  final lines = targetFile.readAsLinesSync();
  final output = StringBuffer();
  bool inFlutter = false;
  bool inFonts = false;
  int flutterIndent = 0;
  bool hasFlutter = false;

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];

    if (line.trimLeft().startsWith('flutter:')) {
      hasFlutter = true;
      inFlutter = true;
      flutterIndent = line.indexOf('flutter:');
      output.writeln(line);
      continue;
    }

    if (inFlutter) {
      final currentIndent = line.length - line.trimLeft().length;

      // Detect existing fonts: line
      if (line.trimLeft().startsWith('fonts:') && currentIndent > flutterIndent) {
        inFonts = true;
        continue;
      }

      // End of old fonts block
      if (inFonts && (line.trim().isEmpty || currentIndent <= flutterIndent + 1)) {
        output.write(fontBlock.toString());
        inFonts = false;
      }

      if (inFonts) continue;
    }

    output.writeln(line);
  }

  // If flutter block exists but no fonts block found, append it
  if (hasFlutter && !output.toString().contains('fonts:\n')) {
    output.write(fontBlock.toString());
  }

  // If flutter block does not exist, add full block
  if (!hasFlutter) {
    print('ℹ️ No `flutter:` section found — appending it at the end.');
    output.writeln();
    output.writeln('flutter:');
    output.write(fontBlock.toString());
  }

  targetFile.writeAsStringSync(output.toString());
  print('✅ Fonts updated in "$targetPath" using fonts from "$fontsDirPath"');
}
