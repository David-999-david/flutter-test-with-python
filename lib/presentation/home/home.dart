import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/presentation/home/home_state.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final cateState = ref.watch(categoryProvider(''));
    return Scaffold(
      body: Center(
        child: cateState.isLoading
            ? CircularProgressIndicator()
            : cateState.value!.isEmpty
            ? Text('There is no Category')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(cateState.value!.length, (i) {
                  return Text(cateState.value![i].name);
                }),
              ),
      ),
    );
  }
}
