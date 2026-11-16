class DeepLinks {
  DeepLinks._();

  static const host = 'instant-flutter-course.web.app';

  static Uri listing(String id) => Uri.https(host, '/l/$id');
}