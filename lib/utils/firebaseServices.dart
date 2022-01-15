import 'dart:convert';
import 'package:nexus/utils/constants.dart';
import 'package:http/http.dart' as http;

Future<void> createNewNexusUser(
    String email, String title, String username, String uid) async {
  final String api = constants().fetchApi + 'users/$uid.json';
  try {
    await http.put(Uri.parse(api),
        body: json.encode({
          'title': title,
          'username': username,
          'email': email,
          'bio': '',
          'dp': '',
          'uid': '',
          'coverImage': '',
          'followers': [],
          'followings': [],
        }));
  } catch (error) {
    print(error);
  }
}
