mixin ComparableMixin implements Comparable {
  /// sort users by member role and then by name
  @override
  int compareTo(other) => cmpTo(other) ?? 0;

  int? cmpTo(other);
}

extension NullableComparable on Comparable {
  int? cmpTo(other) {
    final result = compareTo(other);
    if (result == 0) return null;
    return result;
  }
}

abstract class Cmp<T> {
  static int? compare(Comparable a, Comparable b) => a.cmpTo(b);
}
