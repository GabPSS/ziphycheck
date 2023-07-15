import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:flutter/material.dart';

class ObjectTypeEditorPage extends StatefulWidget {
  final DataMaster dm;
  final ObjectType? objectType;
  final bool isAdding;
  final Function()? onUpdate;

  const ObjectTypeEditorPage({super.key, required this.dm, this.objectType, this.isAdding = false, this.onUpdate});

  @override
  State<ObjectTypeEditorPage> createState() => _ObjectTypeEditorPageState();
}

class _ObjectTypeEditorPageState extends State<ObjectTypeEditorPage> {
  late ObjectType objectType;
  final formKey = GlobalKey<FormState>();
  bool isAdding = false;

  @override
  void initState() {
    if (widget.isAdding) {
      objectType = ObjectType(dm: widget.dm);
      isAdding = true;
    } else {
      assert(widget.objectType != null);
      objectType = widget.objectType!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mainWidgets = <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
          ),
          initialValue: objectType.name,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            if (formKey.currentState!.validate()) {
              objectType.name = value.trim();
              update();
            }
          },
          validator: (value) {
            if (value?.trim().isEmpty ?? true) {
              return "Enter a name";
            }
            return null;
          },
        ),
      ),
    ].toList(growable: true);

    Iterable<Widget> map = widget.dm.tasks.map((task) => CheckboxListTile(
          value: objectType.hasTask(task),
          title: Text(task.name),
          onChanged: (value) {
            setState(() {
              if (value ?? false) {
                objectType.addTask(task);
              } else {
                objectType.removeTask(task);
              }
            });
          },
        ));

    if (map.isNotEmpty) {
      var newMap = <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Available tasks'),
        )
      ];
      newMap.addAll(map);
      map = newMap;
    }

    mainWidgets.addAll(map.isNotEmpty
        ? map
        : [
            const Expanded(
                child: Center(
              child: Text('There are no tasks to add right now. Add some, then come back later'),
            ))
          ].toList());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Discard changes?'),
                    content: const Text('Closing will discard changes to this object type due to invalid inputs'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            if (isAdding) {
                              widget.dm.objectTypes.remove(objectType);
                            }
                          },
                          child: const Text('Discard'))
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(isAdding ? 'Add object type' : 'Edit object type'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: mainWidgets,
        ),
      ),
    );
  }

  void update() {
    if (widget.onUpdate != null) widget.onUpdate!();
  }
}
