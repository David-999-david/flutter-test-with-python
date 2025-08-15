import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/presentation/bottom_nav/bottom_nav_state.dart';
import 'package:testflutt/presentation/home/home.dart';
import 'package:testflutt/presentation/job.dart';
import 'package:testflutt/presentation/settings/setting.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key, this.index = 0});

  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  final List<Widget> screenList = [Home(), Job(), Setting()];

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(navState(widget.index))!;

    return Scaffold(
      body: screenList[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          ref.read(navState(widget.index).notifier).onSelect(value);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Job'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}
