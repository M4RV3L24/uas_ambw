import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  NotesProvider() {
    loadNotes();
  }

  // Load notes from SharedPreferences
  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString('notes');
    
    if (notesJson != null) {
      final List<dynamic> notesList = json.decode(notesJson);
      _notes = notesList.map((json) => Note.fromJson(json)).toList();
      notifyListeners();
    }
  }

  // Save notes to SharedPreferences
  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = json.encode(_notes.map((note) => note.toJson()).toList());
    await prefs.setString('notes', notesJson);
  }

  // Add new note
  Future<void> addNote(String title, String content) async {
    final note = Note(
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    _notes.insert(0, note);
    await saveNotes();
    notifyListeners();
  }

  // Edit note
  Future<void> editNote(int index, String title, String content) async {
    _notes[index] = Note(
      title: title,
      content: content,
      createdAt: _notes[index].createdAt, // Keep original creation date
    );
    await saveNotes();
    notifyListeners();
  }

  // Delete note
  Future<void> deleteNote(int index) async {
    _notes.removeAt(index);
    await saveNotes();
    notifyListeners();
  }
}