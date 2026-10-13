import '../package_spec.dart';

final class PackageWiringException implements Exception {
  const PackageWiringException(this.message);
  final String message;
  @override
  String toString() => 'PackageWiringException: $message';
}

String registerWorkspacePackage(String content, String name) =>
    _insertBeforeMarker(
      content,
      'fst:packages',
      '  - packages/$name',
    );

String registerPackageCategory(
  String content,
  String name,
  ReusablePackageType type,
) =>
    _insertBeforeMarker(
      content,
      'fst:package-categories',
      "  '$name': PackageCategory.${type.architectureCategory},",
    );

String registerPackageLayer(String content, String name, int layer) =>
    _insertBeforeMarker(
      content,
      'fst:package-layers',
      "  '$name': $layer,",
    );

Map<String, int> parseArchitectureLayers(String content) => {
      for (final match in RegExp(
        r"^\s*'([a-zA-Z0-9_]+)':\s*(\d+),",
        multiLine: true,
      ).allMatches(content))
        match.group(1)!: int.parse(match.group(2)!),
    };

String _insertBeforeMarker(String content, String marker, String line) {
  if (content.split('\n').contains(line)) return content;
  final lines = content.split('\n');
  final index = lines.indexWhere((candidate) => candidate.contains(marker));
  if (index == -1) {
    throw PackageWiringException(
      'Missing // $marker marker required for safe package registration.',
    );
  }
  lines.insert(index, line);
  return lines.join('\n');
}
