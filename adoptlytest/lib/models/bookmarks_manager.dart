class BookmarksManager {
  // Internal list to store bookmarked pets
  static final List<Map<String, dynamic>> _bookmarks = [];

  // Get the list of bookmarks
  static List<Map<String, dynamic>> getBookmarks() => _bookmarks;

  // Add a pet to the bookmarks
  static void addBookmark(Map<String, dynamic> pet) {
    // Avoid duplicate bookmarks by checking the pet's name
    if (!_bookmarks.any((bookmark) => bookmark['name'] == pet['name'])) {
      _bookmarks.add(pet);
    }
  }

  // Remove a pet from the bookmarks by name
  static void removeBookmark(String petName) {
    _bookmarks.removeWhere((bookmark) => bookmark['name'] == petName);
  }

  // Check if a pet is bookmarked
  static bool isBookmarked(String petName) {
    return _bookmarks.any((bookmark) => bookmark['name'] == petName);
  }
}
