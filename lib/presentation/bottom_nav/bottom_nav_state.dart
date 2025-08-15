import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavNotifier extends StateNotifier<int?> {
  BottomNavNotifier(this.ref,this.index) : super(index);

  final Ref ref;
  late int index;

  void onSelect(int i) {
    state = i;
  }
}

final navState = StateNotifierProvider.family<BottomNavNotifier, int?, int>(
  (ref, index) => BottomNavNotifier(ref,index),
);
