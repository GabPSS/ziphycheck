import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObjectTypeEditorPage extends StatefulWidget {
  final ObjectType? objectType;
  bool get isAdding => objectType == null;

  const ObjectTypeEditorPage({super.key, this.objectType});

  @override
  State<ObjectTypeEditorPage> createState() => _ObjectTypeEditorPageState();
}

class _ObjectTypeEditorPageState extends State<ObjectTypeEditorPage> {
  late ObjectType objectType;
  late DataMaster dm;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    dm = Provider.of<DataMaster>(context, listen: false);
    if (widget.isAdding) {
      objectType = ObjectType();
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

    Iterable<Widget> map = dm.checks.map((check) => CheckboxListTile(
          value: objectType.hasCheck(check),
          title: Text(check.name),
          onChanged: (value) {
            setState(() {
              if (value ?? false) {
                objectType.addCheck(check);
              } else {
                objectType.removeCheck(check);
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
              child: Text(
                  'There are no tasks to add right now. Add some, then come back later'),
            ))
          ].toList());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                if (widget.isAdding) {
                  dm.addObject(objectType);
                } else {
                  dm.update();
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Discard changes?'),
                    content: const Text(
                        'Closing will discard changes to this object type due to invalid inputs'),
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
                          },
                          child: const Text('Discard'))
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(widget.isAdding ? 'Add object type' : 'Edit object type'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: mainWidgets,
        ),
      ),
    );
  }
}
