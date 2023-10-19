import 'package:animations/animations.dart';
import 'package:bottom/Providers/DataBaseProvider.dart';
import 'package:bottom/new_item.dart';
import 'package:bottom/widgets/showGridView.dart';
import 'package:bottom/widgets/showListView.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

final formatterForDate = DateFormat.yMd();
final formatterForTime = DateFormat('h:mm a');

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  bool _isListView = true;

  @override
  void initState() {
    super.initState();
    ref.read(DataBaseProvider.notifier).getData();
  }

  @override
  Widget build(BuildContext context) {
    final Notes = ref.watch(DataBaseProvider);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          '  Notes',
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isListView = !_isListView;
                });
              },
              icon: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(
                  _isListView
                      ? Icons.grid_view_rounded
                      : Icons.format_list_bulleted,
                  size: 34,
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: _isListView
            ? showListView(notes: Notes)
            : showGridView(Notes: Notes),
      ),
      floatingActionButton: OpenContainer(
        closedElevation: 5,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        transitionType: ContainerTransitionType.fade,
        closedBuilder: (context, action) => FloatingActionButton(
          onPressed: action,
          child: const Icon(Icons.add),
        ),
        openBuilder: (context, action) => NewItem(),
        tappable: true,
      ),
    );
  }
}
