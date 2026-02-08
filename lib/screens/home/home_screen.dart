import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showEditDialog(BuildContext context, String id, String oldTitle) {
    final editController = TextEditingController(text: oldTitle);
    final editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Edit task"),
          content: Form(
            key: editFormKey,
            child: TextFormField(
              controller: editController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Task cannot be empty";
                }
                if (value.trim().length > 80) {
                  return "Max 80 characters";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Update task",
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (!editFormKey.currentState!.validate()) return;

                context.read<TodoProvider>().editTask(
                      id,
                      editController.text.trim(),
                    );

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todo = context.read<TodoProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text("Todo app"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== ADD TASK SECTION =====
              const Text(
                "Add tasks",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Form(
                key: todo.addFormKey,
                child: TextFormField(
                  controller: todo.taskController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Task cannot be empty";
                    }
                    if (value.trim().length > 80) {
                      return "Max 80 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter task",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TodoProvider>().addTask();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Add Task",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ===== TASK LIST SECTION =====
              const Text(
                "Tasks",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Consumer<TodoProvider>(
                builder: (context, provider, _) {
                  if (provider.tasks.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Center(
                        child: Text(
                          "No tasks yet",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = provider.tasks[index];

                      return Container(
                        key: ValueKey(task.id),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) {
                              context
                                  .read<TodoProvider>()
                                  .toggleTask(task.id);
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditDialog(
                                  context,
                                  task.id,
                                  task.title,
                                );
                              } else {
                                context
                                    .read<TodoProvider>()
                                    .deleteTask(task.id);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text("Edit"),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text("Delete"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
