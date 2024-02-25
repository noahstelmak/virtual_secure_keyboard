abstract class VirtualKey<T> {
  const VirtualKey({
    required this.label,
    required this.value,
  });

  final String label;
  final T value;
}

class NumericVirtualKey extends VirtualKey<int> {
  const NumericVirtualKey._({
    required super.label,
    required super.value,
  });

  static List<NumericVirtualKey> get allKeys => List.generate(
        10,
        (index) => NumericVirtualKey._(
          label: index.toString(),
          value: index,
        ),
        growable: false,
      );
}

class IndexedVirtualKey extends VirtualKey<int> {
  const IndexedVirtualKey({required super.label, required super.value});

  static List<IndexedVirtualKey> indexedKeys(List<String> labels) =>
      List.generate(
        labels.length,
        (index) => IndexedVirtualKey(
          label: labels[index],
          value: index,
        ),
        growable: false,
      );
}
