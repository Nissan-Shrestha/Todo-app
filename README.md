# Flutter Todo App

A simple Todo application built with **Flutter** using **Provider** for state management.

## Features

- Add new tasks
- Edit tasks via popup dialog
- Delete tasks
- Mark tasks as completed with a checkbox
- Form validation (empty input & max length)
- Clean and simple UI

## State Management

This app uses **Provider** to manage state:
- Tasks are stored in memory
- UI updates automatically using `notifyListeners()`

> Note: Tasks are not persisted and will reset when the app restarts.

## Project Structure

lib/
├── models/
│   └── task.dart
├── providers/
│   └── todo_provider.dart
├── screens/
│   └── home_screen.dart
└── main.dart

## How It Works

- `TodoProvider` manages the list of tasks
- UI listens to provider changes
- All task actions (add, edit, delete, toggle) go through the provider
- Editing a task opens a popup dialog with its own form field

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Run the app using `flutter run`

## Dependencies

provider: ^6.0.0

## Screens

- Home screen with task list
- Popup menu on each task for edit/delete
- Edit task dialog with validation

## Author

Built as a learning project to understand Flutter UI, Provider state management, and basic CRUD operations.
