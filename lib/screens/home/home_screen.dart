import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              decoration: const InputDecoration(hintText: "Update task"),
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
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
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
              const Text(
                "Add tasks",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _taskController,
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
                    if (!_formKey.currentState!.validate()) return;
                    todoProvider.addTask(_taskController.text.trim());
                    _taskController.clear();
                    _formKey.currentState!.reset();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Add Task",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "Tasks",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              todoProvider.tasks.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Center(
                        child: Text(
                          "No tasks yet",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: todoProvider.tasks.length,
                      itemBuilder: (context, index) {
                        final task = todoProvider.tasks[index];

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
                                todoProvider.toggleTask(task.id);
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
                                  _showEditDialog(context, task.id, task.title);
                                } else {
                                  todoProvider.deleteTask(task.id);
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
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
