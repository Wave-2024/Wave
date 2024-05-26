import 'dart:math';

import 'package:get/get.dart';
import 'package:wave/utils/constants/database_endpoints.dart';

String capitalizeWords(String input) {
  // Split the string into words
  List<String> words = input.split(' ');

  // Capitalize the first letter of each word
  List<String> capitalizedWords = words.map((word) {
    if (word.isEmpty) return word;
    // Ensure the first letter is capitalized and the rest are lower case
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).toList();

  // Join all the words back into a single string
  return capitalizedWords.join(' ');
}

DateTime calculateTimeAgo(DateTime createdAt) {
  DateTime difference = DateTime.now().subtract(Duration(
      days: DateTime.now().day - createdAt.day,
      hours: DateTime.now().hour - createdAt.hour,
      minutes: DateTime.now().minute - createdAt.minute));

  return difference;
}

String getInitials(String fullName) {
  if (fullName.length >= 3) {
    "returning substring from full name : ${fullName.replaceAll(' ', '').substring(0, 3).toLowerCase()}"
        .printInfo();
    return fullName.replaceAll(' ', '').substring(0, 3).toLowerCase();
  } else {
    return "wave";
  }
}

String generateUsername(String initials) {
  final random = Random();
  final randomDigits =
      random.nextInt(90000) + 1000; // Generate a random 5-digit number
  return '$initials$randomDigits';
}

Future<bool> checkUsernameUniqueness(String username) async {
  final querySnapshot =
      await Database.userDatabase.where('username', isEqualTo: username).get();
  return querySnapshot.docs.isEmpty;
}

Future<String> getUniqueUsername(String initials) async {
  initials = getInitials(initials);
  String username = 'wave';
  bool isUnique = false;
  while (!isUnique) {
    username = generateUsername(initials);
    isUnique = await checkUsernameUniqueness(username);
  }
  return username;
}

String getMonthName(int month) {
  Map<int, String> months = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "June",
    7: "July",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };
  return months[month]!;
}
