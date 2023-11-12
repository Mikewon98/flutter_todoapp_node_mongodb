import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../provider/todo_provider.dart';

TextEditingController textController = TextEditingController();

Future<void> addDataWidget(BuildContext context, TaskModel taskModel) async {
  textController.text = taskModel.text == '' ? '' : taskModel.text;

  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          height: 500,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(hintText: 'Add Text'),
              ),
              ElevatedButton(
                onPressed: taskModel.text == ''
                    ? () async {
                        if (textController.text.isNotEmpty) {
                          await Provider.of<TodoProvider>(context,
                                  listen: false)
                              .addData({
                            "text": textController.text,
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Task added')));
                        }
                      }
                    : () async {
                        await context.read<TodoProvider>().updateData(
                          taskModel.id,
                          {"text": textController.text},
                        );

                        Navigator.pop(context);
                      },
                child: taskModel.text == ''
                    ? const Text('Submit')
                    : const Text('Update'),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      );
    },
  );
}
