import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Job extends ConsumerStatefulWidget{
  const Job({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JobState();
}

class _JobState extends ConsumerState<Job> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Job'),
      ),
    );
  }
}