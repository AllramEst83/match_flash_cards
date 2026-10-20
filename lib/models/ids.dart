import 'dart:math';

final _random = Random();

String newId() =>
    '${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1 << 32)}';
