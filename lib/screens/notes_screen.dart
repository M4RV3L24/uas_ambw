import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/notes_provider.dart';
import '../theme_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Catatan Saya'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
          body: Consumer<NotesProvider>(
            builder: (context, notesProvider, child) {
              final filteredNotes = notesProvider.notes.where((note) {
                return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                       note.content.toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Cari catatan...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: filteredNotes.isEmpty && _searchQuery.isNotEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ada catatan yang ditemukan.',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : filteredNotes.isEmpty
                            ? const Center(
                                child: Text(
                                  'Belum ada catatan.\nTekan + untuk menambah catatan baru.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredNotes.length,
                                itemBuilder: (context, index) {
                                  final note = filteredNotes[index];
                                  final originalIndex = notesProvider.notes.indexOf(note);
                                  final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(note.createdAt);
                                  
                                  return Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/add-note',
                                          arguments: {'note': note, 'index': originalIndex},
                                        );
                                      },
                                      title: Text(
                                        note.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            note.content,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: themeProvider.themeMode == ThemeMode.dark 
                                                  ? Colors.grey[400] 
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteDialog(context, notesProvider, originalIndex);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-note');
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, NotesProvider notesProvider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              notesProvider.deleteNote(index);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}