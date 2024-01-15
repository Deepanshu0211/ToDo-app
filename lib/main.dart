import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.amber),
      ),
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<String> tasks = [];
  List<String> completedTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do List',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.blue],
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length + completedTasks.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    );
                  } else if (index <= tasks.length) {
                    return buildTaskItem(index - 1);
                  } else if (index == tasks.length + 1) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return buildCompletedTaskItem(index - tasks.length - 2);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  Widget buildTaskItem(int index) {
    return Dismissible(
      key: Key(tasks[index]), // Unique key for each item
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          completedTasks.add(tasks.removeAt(index));
        });
      },
      background: Container(
        color: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Icon(Icons.check, color: Colors.white),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.grey[900],
        child: ListTile(
          title: Text(
            tasks[index],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              setState(() {
                tasks.removeAt(index);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget buildCompletedTaskItem(int index) {
    return Dismissible(
      key: Key(completedTasks[index]), // Unique key for each item
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          tasks.add(completedTasks.removeAt(index));
        });
      },
      background: Container(
        color: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        child: Icon(Icons.undo, color: Colors.white),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.grey[800],
        child: ListTile(
          title: Text(
            completedTasks[index],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.lineThrough,
              color: Colors.white,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.undo),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              setState(() {
                tasks.add(completedTasks.removeAt(index));
              });
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    TextEditingController taskController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a New Task'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(
              hintText: 'Enter your task...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks.add(taskController.text);
                  taskController.clear();
                  Navigator.of(context).pop();
                });
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
