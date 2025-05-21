import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  // Database setup
  final dbPath = p.join(Directory.current.path, 'students.db');
  final db = sqlite3.open(dbPath);

  // Create table if it doesn't exist
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL CHECK(length(nome) <= 50)
    );
  ''');

  // Main menu loop
  while (true) {
    print('\n--- Student Menu ---');
    print('1. Insert student');
    print('2. List students');
    print('3. Exit');
    stdout.write('Choose an option: ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        _insertStudent(db);
        break;
      case '2':
        _listStudents(db);
        break;
      case '3':
        db.dispose();
        print('Goodbye!');
        exit(0);
      default:
        print('Invalid option. Please try again.');
    }
  }
}

void _insertStudent(Database db) {
  stdout.write('Enter student name (max 50 chars): ');
  final name = stdin.readLineSync()?.trim();

  if (name == null || name.isEmpty) {
    print('Name cannot be empty.');
    return;
  }

  if (name.length > 50) {
    print('Name is too long (max 50 characters).');
    return;
  }

  final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?)');
  stmt.execute([name]);
  stmt.dispose();

  print('Student "$name" added successfully.');
}

void _listStudents(Database db) {
  final ResultSet result = db.select('SELECT id, nome FROM TB_ALUNO');

  if (result.isEmpty) {
    print('No students found.');
    return;
  }

  print('\n--- Student List ---');
  for (final row in result) {
    print('ID: ${row['id']} - Name: ${row['nome']}');
  }
}
