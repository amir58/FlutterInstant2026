class Note {
  const Note({required this.title, required this.body});

  final String title;
  final String body;
}

// بيانات تجريبية — في تطبيق حقيقي هتيجي من API أو SQLite
const notes = [
  Note(title: 'مذاكرة Flutter', body: 'أخلص درس الثيمات وأجرّب الداكن'),
  Note(title: 'طلبات البيت', body: 'لبن، عيش، بن، وبطاريات للريموت'),
  Note(title: 'أفكار للتطبيق', body: 'زرار يقلب المود من الـ AppBar'),
];