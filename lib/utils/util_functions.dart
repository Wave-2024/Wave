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
