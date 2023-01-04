mixin ComparableMixin implements Comparable {
  /// sort users by member role and then by name
  @override
  int compareTo(other) => nCompareTo(other) ?? 0;

  int? nCompareTo(other);
}

extension NullableComparable on Comparable {
  int? nCompareTo(other) {
    final result = compareTo(other);
    if (result == 0) return null;
    return result;
  }
}

extension NullableSort<T> on List<T> {
  void nSort([int? Function(T a, T b)? nCompare]) =>
      nCompare == null ? sort() : sort((a, b) => nCompare(a, b) ?? 0);
}
