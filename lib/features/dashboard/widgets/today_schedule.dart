import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_track/features/courses/models/course.dart';
import 'package:uni_track/features/courses/services/courses_provider.dart';
import 'package:uni_track/features/schedule/models/schedule_item.dart';
import 'package:uni_track/features/schedule/services/schedule_provider.dart';

class TodaySchedule extends StatelessWidget {
  const TodaySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final primary = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.05,
        screenHeight * 0.02,
        screenWidth * 0.05,
        screenHeight * 0.03,
      ),
      decoration: BoxDecoration(color: theme.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Schedule",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _showItemDialog(context),
                    icon: const Icon(Icons.add),
                    tooltip: 'Add schedule item',
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      children: [
                        Text(
                          'View all',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: primary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer2<ScheduleProvider, CoursesProvider>(
            builder: (context, scheduleProvider, coursesProvider, _) {
              final items = scheduleProvider.itemsForToday();

              if (items.isEmpty) {
                return _buildEmptyState();
              }

              return Column(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final course = _findCourse(
                    coursesProvider.courses,
                    item.courseId,
                  );
                  final color = course?.color ?? Colors.blueGrey;
                  final courseLabel = course?.code ?? 'Personal';
                  final title = item.title.isNotEmpty
                      ? item.title
                      : (course?.name ?? 'Schedule item');

                  return Column(
                    children: [
                      _buildScheduleItem(
                        context: context,
                        scheduleProvider: scheduleProvider,
                        item: item,
                        courseLabel: courseLabel,
                        title: title,
                        location: item.location ?? '',
                        color: color,
                        time: _formatTime(item.time),
                      ),
                      if (index != items.length - 1) const SizedBox(height: 16),
                    ],
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Course? _findCourse(List<Course> courses, String? courseId) {
    if (courseId == null) return null;
    for (final c in courses) {
      if (c.id == courseId) return c;
    }
    return null;
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Text(
        'Nothing scheduled for today',
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
    );
  }

  String _formatTime(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return hhmm;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h % 12 == 0 ? 12 : h % 12;
    final mm = m.toString().padLeft(2, '0');
    return '$hour12:$mm $period';
  }

  Future<void> _showItemDialog(
    BuildContext context, {
    ScheduleItem? existing,
  }) async {
    final coursesProvider = context.read<CoursesProvider>();
    final scheduleProvider = context.read<ScheduleProvider>();

    final result = await showDialog<ScheduleItem>(
      context: context,
      builder: (ctx) => _ScheduleItemDialog(
        existing: existing,
        courses: coursesProvider.courses,
      ),
    );

    if (result == null) return;

    if (existing == null) {
      await scheduleProvider.addItem(result);
    } else {
      await scheduleProvider.updateItem(existing.id, result);
    }
  }

  Widget _buildScheduleItem({
    required BuildContext context,
    required ScheduleProvider scheduleProvider,
    required ScheduleItem item,
    required String courseLabel,
    required String title,
    required String location,
    required Color color,
    required String time,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showItemDialog(context, existing: item),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.18), width: 1),
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$courseLabel · $title',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (location.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          location,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert, size: 18, color: Colors.grey[400]),
              onSelected: (value) {
                if (value == 'edit') {
                  _showItemDialog(context, existing: item);
                } else if (value == 'delete') {
                  scheduleProvider.deleteItem(item.id);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(
                  value: 'delete',
                  child:
                      Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItemDialog extends StatefulWidget {
  final ScheduleItem? existing;
  final List<Course> courses;

  const _ScheduleItemDialog({this.existing, required this.courses});

  @override
  State<_ScheduleItemDialog> createState() => _ScheduleItemDialogState();
}

class _ScheduleItemDialogState extends State<_ScheduleItemDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _locationCtrl;
  late TimeOfDay _time;
  late ScheduleRecurrence _recurrence;
  int? _dayOfWeek;
  DateTime? _date;
  String? _courseId;

  static const _weekdayLabels = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday',
  };

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _locationCtrl = TextEditingController(text: e?.location ?? '');
    _recurrence = e?.recurrence ?? ScheduleRecurrence.weekly;
    _dayOfWeek = e?.dayOfWeek ?? DateTime.now().weekday;
    _date = e?.date;
    _courseId = e?.courseId;

    if (e != null) {
      final parts = e.time.split(':');
      _time = TimeOfDay(
        hour: int.tryParse(parts.first) ?? 9,
        minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
      );
    } else {
      _time = const TimeOfDay(hour: 9, minute: 0);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  String get _timeAsHHmm =>
      '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existing == null ? 'Add schedule item' : 'Edit schedule item',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title (e.g. Lecture, Lab, Career fair)',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              value: _courseId,
              decoration: const InputDecoration(labelText: 'Course (optional)'),
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Standalone (no course)'),
                ),
                ...widget.courses.map(
                  (c) => DropdownMenuItem<String?>(
                    value: c.id,
                    child: Text('${c.code} · ${c.name}'),
                  ),
                ),
              ],
              onChanged: (v) => setState(() => _courseId = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationCtrl,
              decoration:
                  const InputDecoration(labelText: 'Location (optional)'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<ScheduleRecurrence>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Weekly'),
                    value: ScheduleRecurrence.weekly,
                    groupValue: _recurrence,
                    onChanged: (v) => setState(() {
                      _recurrence = v!;
                    }),
                  ),
                ),
                Expanded(
                  child: RadioListTile<ScheduleRecurrence>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('One-off'),
                    value: ScheduleRecurrence.oneOff,
                    groupValue: _recurrence,
                    onChanged: (v) => setState(() {
                      _recurrence = v!;
                    }),
                  ),
                ),
              ],
            ),
            if (_recurrence == ScheduleRecurrence.weekly)
              DropdownButtonFormField<int>(
                value: _dayOfWeek,
                decoration: const InputDecoration(labelText: 'Day of week'),
                items: _weekdayLabels.entries
                    .map(
                      (e) => DropdownMenuItem<int>(
                        value: e.key,
                        child: Text(e.value),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _dayOfWeek = v),
              )
            else
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(
                  _date == null
                      ? 'Pick a date'
                      : '${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _date = picked);
                  }
                },
              ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Time'),
              subtitle: Text(_time.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final picked =
                    await showTimePicker(context: context, initialTime: _time);
                if (picked != null) setState(() => _time = picked);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _onSave,
          child: Text(widget.existing == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }

  void _onSave() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    if (_recurrence == ScheduleRecurrence.oneOff && _date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a date')),
      );
      return;
    }

    final id = widget.existing?.id ??
        's${DateTime.now().millisecondsSinceEpoch}';
    final location = _locationCtrl.text.trim();

    final item = ScheduleItem(
      id: id,
      courseId: _courseId,
      title: title,
      location: location.isEmpty ? null : location,
      time: _timeAsHHmm,
      recurrence: _recurrence,
      dayOfWeek:
          _recurrence == ScheduleRecurrence.weekly ? _dayOfWeek : null,
      date: _recurrence == ScheduleRecurrence.oneOff ? _date : null,
    );

    Navigator.of(context).pop(item);
  }
}
