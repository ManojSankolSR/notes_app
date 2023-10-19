import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/new_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:bottom/Providers/DataBaseProvider.dart';
import 'package:bottom/HomeScreeen.dart';
import 'package:animations/animations.dart';

class showGridView extends ConsumerWidget {
  final List<DataModel> Notes;
  showGridView({super.key, required this.Notes});
  void snack(BuildContext context) {}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StaggeredGridView.countBuilder(
      itemCount: Notes.length,
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(Notes[index].id),
          onDismissed: (direction) async {
            final delnote =
                await ref.read(DataBaseProvider.notifier).delete(Notes[index]);
            if (context.mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Row(
                    children: [
                      const Text("Note Deleted"),
                      TextButton(
                          onPressed: () async {
                            ref
                                .read(DataBaseProvider.notifier)
                                .addNote(delnote);
                            ScaffoldMessenger.of(context).clearSnackBars();
                          },
                          child: const Text('Undo...'))
                    ],
                  )));
            }
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
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      color: Colors.primaries[index % Colors.primaries.length],
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    Notes[index].title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(child: Text(Notes[index].note)),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    formatterForTime.format(Notes[index].date)),
                                const Spacer(),
                                Text(
                                    formatterForDate.format(Notes[index].date)),
                              ],
                            )
                          ],
                        )),
                  ),
                );
                //OpenContainer(
                //   closedBuilder: (context, action) => InkWell(
                //     onTap: action,
                //     child: Container(
                //       color: _Gridcolor,
                //       child: Padding(
                //         padding: const EdgeInsets.all(15),
                //         child: Text(Notes[index].note),
                //       ),
                //     ),
                //   ),
                //   openBuilder: (context, action) =>
                //       NewItem(value: 'sdbhsbsbjdfbajkbfjabjsfj'),
                // );
              },
              openBuilder: (context, action) {
                return NewItem(
                  Note: Notes[index],
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              },
            ),
          ),
        );
      },
      staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
    );
  }
}
