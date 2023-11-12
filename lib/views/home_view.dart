import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../provider/todo_provider.dart';
import 'add_todo.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(255, 10, 252, 135),
        // backgroundColor: Colors.orange,
        title: const Text(
          'TODO List',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<TaskModel>>(
        future: context.read<TodoProvider>().fetchData(),
        builder: (context, snapshot) {
          List<TaskModel> tasks = snapshot.data ?? [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (tasks.isEmpty) {
            return const Center(
              child: Text('Empty List'),
            );
          }

          return ListView.separated(
            itemCount: tasks.length,
            itemBuilder: (_, index) {
              return ListTile(
                // tileColor: const Color.fromARGB(255, 248, 182, 96),
                title: Text(
                  tasks[index].text,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: FittedBox(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await context
                              .read<TodoProvider>()
                              .deleteData({"_id": tasks[index].id});

                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Task deleted')));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await addDataWidget(context, tasks[index]);
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Task edited')));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, int index) => const Divider(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addDataWidget(context, TaskModel(id: '', text: ''));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
