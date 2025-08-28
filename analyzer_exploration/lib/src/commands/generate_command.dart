import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:args/command_runner.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;

/// {@template sample_command}
///
/// `analyzer_exploration sample`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class GenerateCommand extends Command<int> {
  /// {@macro sample_command}
  GenerateCommand({required Logger logger}) : _logger = logger;

  @override
  String get description => 'A sample sub command that just prints one joke';

  @override
  String get name => 'generate';

  final Logger _logger;

  @override
  Future<int> run() async {
    final binDir = Directory(path.dirname(Platform.script.toFilePath()));
    final libDir = Directory(
      path.joinAll([binDir.parent.absolute.path, 'lib']),
    );

    var collection = AnalysisContextCollection(
      includedPaths: [libDir.absolute.path],
    );

    assert(collection.contexts.length == 1, 'Totally expected 1 context');
    final context = collection.contexts.first;
    final session = context.currentSession;

    for (final filePath in context.contextRoot.analyzedFiles()) {
      if (!filePath.endsWith('.dart')) {
        continue;
      }

      // final st = DateTime.now();
      // print('Starting to analyze $filePath');
      final result = await session.getResolvedUnit(filePath);
      // print('analyzed after ${DateTime.now().difference(st).inMilliseconds}');
      if (result is ResolvedUnitResult) {
        final unit = result.unit;

        for (final declaration in unit.declarations) {
          if (declaration is ClassDeclaration) {
            for (final annotation in declaration.metadata) {
              if (annotation.name.name == 'Annotation') {
                print(buildRepositoryClass(declaration));
              }
            }
          }
        }
      }
    }
    return 0;
  }

  String buildRepositoryClass(ClassDeclaration kls) {
    final _dartfmt = DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    );

    final repo = Class(
      (b) => b
        ..name = '${kls.name}Repository'
        ..fields.add(
          Field(
            (f) => f
              ..name = '_cache'
              ..modifier = FieldModifier.final$
              ..assignment = Code('<String, ${kls.name}>{}'),
          ),
        )
        ..methods.add(
          Method(
            (m) => m
              ..name = 'getById'
              ..returns = refer('${kls.name}?')
              ..requiredParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'id'
                    ..type = refer('String'),
                ),
              )
              ..body = const Code('return _cache[id];'),
          ),
        )
        ..methods.add(
          Method(
            (m) => m
              ..name = 'save'
              ..returns = refer('void')
              ..requiredParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'obj'
                    ..type = refer('${kls.name}'),
                ),
              )
              ..body = const Code('_cache[obj.id] = obj;'),
          ),
        ),
    );

    return _dartfmt.format('${repo.accept(DartEmitter())}');
  }
}
