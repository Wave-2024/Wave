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

String getMonthName(int month){
  Map<int,String> months = {
    1:"Jan",
    2:"Feb",
    3:"Mar",
    4:"Apr",
    5:"May",
    6:"June",
    7:"July",
    8:"Aug",
    9:"Sep",
    10:"Oct",
    11:"Nov",
    12:"Dec",

  };
  return months[month]!;
}
