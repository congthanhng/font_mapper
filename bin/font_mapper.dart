import 'package:args/args.dart';
import 'package:font_mapper/font_mapper.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('target', abbr: 't', help: 'Path to the pubspec.yaml file.', defaultsTo: 'pubspec.yaml')
    ..addOption('dir', abbr: 'd', help: 'Path to the font directory.', defaultsTo: 'assets/fonts')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage information.');

  final ArgResults args = parser.parse(arguments);

  if (args['help'] as bool) {
    print('''
📦 font_mapper - Automatically generate pubspec.yaml font entries.

Usage:
  font_mapper [options]

Options:
${parser.usage}
    ''');
    return;
  }

  final target = args['target'] as String;
  final fontDir = args['dir'] as String;

  runFontMapper(targetPath: target, fontsDirPath: fontDir);
}
