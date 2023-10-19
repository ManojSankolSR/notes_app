import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Providers/DataBaseProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewItem extends ConsumerStatefulWidget {
  final DataModel? Note;
  final color;
  NewItem({
    this.Note,
    this.color,
    super.key,
  });

  @override
  ConsumerState<NewItem> createState() => _NewItemState();
}

class _NewItemState extends ConsumerState<NewItem> {
  @override
  Widget build(BuildContext context) {
    final noteController = widget.Note == null
        ? TextEditingController()
        : TextEditingController(text: widget.Note!.note);
    final titleController = widget.Note == null
        ? TextEditingController()
        : TextEditingController(text: widget.Note!.title);
    bool _isSaved = false;
    void _dialoge() {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Warning"),
                actions: [
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Please Enter Some Text",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ));
    }

    void save() async {
      if (noteController.text.isEmpty || titleController.text.isEmpty) {
        _dialoge();
      }
      if (noteController.text.isNotEmpty && titleController.text.isNotEmpty) {
        if (widget.Note == null) {
          ref.read(DataBaseProvider.notifier).addNote(
                DataModel(
                    id: uuid.v4(),
                    date: DateTime.now(),
                    title: titleController.text,
                    note: noteController.text),
              );
        }
        if (widget.Note != null) {
          ref.read(DataBaseProvider.notifier).update(
              noteController.text, titleController.text, widget.Note!.id);
        }
        _isSaved = true;
        return;
      }
    }

    @override
    void dispose() {
      super.dispose();
      noteController.dispose();
      titleController.dispose();
    }
    return Scaffold(
        backgroundColor: widget.color,
        appBar: AppBar(
          backgroundColor: widget.color,
          title: Text(
            widget.Note != null ? "Notes" : "Add Item",
            style:const TextStyle(fontSize: 20),
          ),
          leading: IconButton(
              onPressed: () {
                if (widget.Note == null) {
                  if (noteController.text.isNotEmpty &&
                      titleController.text.isNotEmpty) {
                    save();
                    Navigator.pop(context);
                    return;
                  }
                  Navigator.pop(context);
                }

                if (widget.Note != null) {
                  if (noteController.text.isEmpty ||
                      titleController.text.isEmpty) {
                    _dialoge();
                    return;
                  }
                  Navigator.pop(context);
                  save();
                  return;
                }
              },
              icon:const Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
            padding:const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: titleController,
                  
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration:const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Notes Title',
                    hintStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
               
                TextField(
                  style:const TextStyle(
                    fontSize: 18,
                  ),
                  controller: noteController,
                  decoration:const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Note",
                  ),
                  scrollPadding: EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  
                  autofocus: true,
                ),
              ],
            )),
        floatingActionButton: ElevatedButton.icon(
            icon:const Icon(Icons.save),
            onPressed: () {
              save();
              if (_isSaved) {
                Navigator.pop(context);
              }
            },
            label: const Text('Save')));
  }
}
