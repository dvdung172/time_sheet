extension StacktraceExt on StackTrace {
  List<String> getStackTrace({
    int maxFrames = 2,
    int ignoreFirstFrames = 0,
    bool removeAsyncSuspension = true,
  }) {
    assert(maxFrames > 0);
    assert(ignoreFirstFrames >= 0);

    final lines = toString()
        .split('\n')
        .where((element) =>
            !removeAsyncSuspension || element != '<asynchronous suspension>')
        .toList();
    if (lines.length <= maxFrames) {
      return lines;
    } else if (lines.length <= ignoreFirstFrames + maxFrames) {
      return lines.sublist(lines.length - maxFrames, lines.length);
    } else {
      return lines.sublist(ignoreFirstFrames, ignoreFirstFrames + maxFrames);
    }
  }
}
