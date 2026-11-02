import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:navigations/core/theme/theme_toggle_button.dart';
import 'package:navigations/core/utils/theme_x.dart';

import 'note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    // signUp();
    // signIn();
    // FirebaseAuth.instance.signOut();
    // debugPrint(FirebaseAuth.instance.currentUser?.uid ?? 'null');
    // FirebaseAuth.instance.sendPasswordResetEmail(
    //   email: 'jqalhnpljxqftdjmpj@jbsze.com',
    // );

    // google();
  }

  Future<void> google() async {
    // مرة واحدة في main بعد Firebase.initializeApp
    await GoogleSignIn.instance.initialize();

    try {
      // لما المستخدم يدوس الزرار
      final account = await GoogleSignIn.instance.authenticate();

      final credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'jqalhnpljxqftdjmpj@jbsze.com',
        password: 'secret123',
        // password: '123456',
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      debugPrint(e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signUp() async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: 'jqalhnpljxqftdjmpj@jbsze.com',
          password: 'secret123',
        );

    final user = credential
        .user!; // المستخدم اتعمل ودخل كمان — مش محتاج signIn بعدها

    debugPrint(user.email);
    debugPrint(user.uid);

    await user.updateDisplayName('أمير');
    await user
        .sendEmailVerification(); // اختياري: لينك تأكيد على الإيميل
  }

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ملاحظاتي'),
        actions: const [ThemeToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              constraints.maxHeight;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.primary,

                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'صباح الخير 👋\nعندك ٣ ملاحظات',
                  style: text.titleLarge?.copyWith(
                    color: context.colors.onPrimary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text('آخر الملاحظات', style: text.titleMedium),
          const SizedBox(height: 8),
          for (final note in notes) NoteCard(note: note),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('ملاحظة جديدة'),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // final text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title, style: context.text.titleMedium),
            const SizedBox(height: 4),
            Text(
              note.body,
              style: context.text.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
