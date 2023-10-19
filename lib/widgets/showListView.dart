import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/new_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bottom/HomeScreeen.dart';
import 'package:animations/animations.dart';
import 'package:bottom/Providers/DataBaseProvider.dart';

class showListView extends ConsumerWidget {
  final List<DataModel> notes;
  showListView({super.key, required this.notes});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Dismissible(
            key: Key(notes[index].id),
            onDismissed: (direction) async {
              final DelNote = await ref
                  .read(DataBaseProvider.notifier)
                  .delete(notes[index]);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                
                  duration: Duration(seconds: 3),
                  content: Row(
                    children: [
                      const Text("Note Deleted"),
                      const Spacer(),
                      TextButton(
                          onPressed: () async {
                            ref
                                .read(DataBaseProvider.notifier)
                                .addNote(DelNote);
                            ScaffoldMessenger.of(context).clearSnackBars();
                          },
                          child:const Text('Undo...'))
                    ],
                  )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: OpenContainer(
                openColor: Colors.primaries[index % Colors.primaries.length],
                closedColor: Colors.primaries[index % Colors.primaries.length],
                closedBuilder: (context, action) {
                  return InkWell(
                    onTap: action,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color:
                            Colors.primaries[index % Colors.primaries.length],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        notes[index].title,
                                        style:const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        notes[index].note,
                                        style:const TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  formatterForDate.format(notes[index].date),
                                ),
                                const Spacer(),
                                Text(
                                  formatterForTime.format(notes[index].date),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                openBuilder: (context, action) {
                  return NewItem(
                    Note: notes[index],
                    color: Colors.primaries[index % Colors.primaries.length],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
