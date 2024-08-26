typedef SelectorBuilder<T, C> = T Function(C context);

class BuilderSelector<T, C, V> {
  final Map<V, SelectorBuilder<T, C>> valuesMap;
  final Comparator<V> comparator;

  BuilderSelector({
    required this.valuesMap,
    required this.comparator,
  }) : assert(valuesMap.isNotEmpty);

  SelectorBuilder<T, C> builderFor(V value) {
    final entries = valuesMap.entries;
    SelectorBuilder<T, C>? builder;
    var builderDiff = double.maxFinite.toInt();
    for (var entry in entries) {
      final entryDiff = comparator(entry.key, value);
      if (entryDiff > 0 && entryDiff < builderDiff) {
        builder = entry.value;
        builderDiff = entryDiff;
      }
    }
    return builder ?? entries.last.value;
  }
}
