import 'package:flutter/material.dart';
import '../resource/colors/app_colors.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  bool isPinned;

  _Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
  });
}

class _NotesPageState extends State<NotesPage> {
  final List<_Note> _notes = [
    _Note(
      id: '1',
      title: 'Monthly Budget Plan',
      content: 'Keep expenses under \$2000 this month. Focus on reducing food costs and dining out less.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isPinned: true,
    ),
    _Note(
      id: '2',
      title: 'Saving Tips',
      content: 'Cook at home more often. Cancel unused subscriptions. Use public transport instead of cab.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    _Note(
      id: '3',
      title: 'Investment Ideas',
      content: 'Look into index funds, ETFs and SIPs. Consider diversifying into gold and bonds.',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  String _searchQuery = '';

  List<_Note> get _filtered {
    final q = _searchQuery.toLowerCase();
    final all = [..._notes.where((n) => n.isPinned), ..._notes.where((n) => !n.isPinned)];
    if (q.isEmpty) {
      return all;
    }
    return all.where((n) => n.title.toLowerCase().contains(q) || n.content.toLowerCase().contains(q)).toList();
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    }
    return 'just now';
  }

  void _showAddNoteDialog({_Note? editNote}) {
    final titleCtrl = TextEditingController(text: editNote?.title ?? '');
    final contentCtrl = TextEditingController(text: editNote?.content ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            editNote == null ? 'New Note' : 'Edit Note',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: contentCtrl,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(color: isDark ? AppColors.gray400 : AppColors.gray600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textPrimary(context),
                foregroundColor: AppColors.actionForeground(context),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              onPressed: () {
                final title = titleCtrl.text.trim();
                final content = contentCtrl.text.trim();
                if (title.isNotEmpty) {
                  setState(() {
                    if (editNote != null) {
                      editNote.title = title;
                      editNote.content = content;
                    } else {
                      _notes.insert(
                        0,
                        _Note(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: title,
                          content: content,
                          createdAt: DateTime.now(),
                        ),
                      );
                    }
                  });
                  Navigator.pop(ctx);
                }
              },
              child: Text(editNote == null ? 'Add Note' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filtered;
    final pinned = filtered.where((n) => n.isPinned).length;

    // Scaffold hosts notes; the shared app shell supplies the AppBar and bottom navigation.
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      // SafeArea protects note content from system display insets.
      body: SafeArea(
        // Column arranges the search controls and note list vertically.
        child: Column(
          children: [
            // Search field and note/pin counts.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      _chip(Icons.note_outlined, '${_notes.length} Notes', isDark),
                      const SizedBox(width: 8),
                      _chip(Icons.push_pin_outlined, '$pinned Pinned', isDark),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // TextField (Search Notes).
                  TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search notes...',
                      hintStyle: TextStyle(
                        color: isDark ? AppColors.gray500 : AppColors.gray400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: isDark ? AppColors.gray400 : AppColors.gray500,
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.surfaceDark : AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.gray800 : AppColors.gray200,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.gray800 : AppColors.gray200,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),

            // ListView displays filtered notes as ListTiles.
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_add_outlined,
                            size: 48,
                            color: isDark ? AppColors.gray700 : AppColors.gray400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty ? 'No matching notes' : 'No notes yet',
                            style: TextStyle(
                              color: isDark ? AppColors.gray400 : AppColors.gray600,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (_searchQuery.isEmpty)
                            Text(
                              'Tap "New Note" to create one',
                              style: TextStyle(
                                color: isDark ? AppColors.gray600 : AppColors.gray400,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final note = filtered[i];
                        // ListTile (note) retains pin, edit, and delete actions.
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? AppColors.gray800 : AppColors.gray200,
                            ),
                          ),
                          child: ListTile(
                            key: ValueKey(note.id),
                            contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    note.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: note.isPinned ? 'Unpin note' : 'Pin note',
                                  onPressed: () => setState(() => note.isPinned = !note.isPinned),
                                  icon: Icon(
                                    note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                    size: 18,
                                    color: note.isPinned
                                        ? (AppColors.textPrimary(context))
                                        : (isDark ? AppColors.gray500 : AppColors.gray400),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                ),
                                IconButton(
                                  tooltip: 'Edit note',
                                  onPressed: () => _showAddNoteDialog(editNote: note),
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: isDark ? AppColors.gray500 : AppColors.gray400,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                ),
                                IconButton(
                                  tooltip: 'Delete note',
                                  onPressed: () => setState(() => _notes.remove(note)),
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: isDark ? AppColors.gray500 : AppColors.gray400,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 6),
                                Text(
                                  note.content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isDark ? AppColors.gray400 : AppColors.gray600,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: isDark ? AppColors.gray500 : AppColors.gray400,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _timeAgo(note.createdAt),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.gray500 : AppColors.gray400,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.text_snippet_outlined,
                                      size: 12,
                                      color: isDark ? AppColors.gray500 : AppColors.gray400,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${note.content.split(' ').length} words',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.gray500 : AppColors.gray400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // FloatingActionButton (New Note).
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddNoteDialog(),
        backgroundColor: AppColors.textPrimary(context),
        foregroundColor: AppColors.actionForeground(context),
        elevation: 1,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.add, size: 18),
        label: const Text(
          'New Note',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.gray800 : AppColors.gray200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isDark ? AppColors.gray400 : AppColors.gray600,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.gray300 : AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
