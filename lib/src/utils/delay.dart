Future<void> delay(bool addDelay, [int milliseconds = 1000]) async {
  if (addDelay) return Future.delayed(Duration(milliseconds: milliseconds));
}
