Map<String, String> endpoints = {
  "login": "/api/login",
  "register": "/api/register",
  "book-notes": "/api/book-notes",
  "save-note": "/api/save-later",
  "books": "/api/books",
  "top-books": "/api/top-books",
  "comments": "/api/comments",
  "search": "/api/search",
  "logout": "/api/logout",
  "deactivateUser": "/api/deactivate-user",
};

Map<String, String> apiHeader = {
  'Content-type': 'application/json',
  'Accept': 'application/json'
};

Map<String, int> statusCode = {
  "success": 200,
  "error": 400,
  "unauthorized": 401,
  "forbidden": 403,
  "notFound": 404,
  "serverError": 500,
};

Map<String, String> textFieldErrors = {
  'username': 'Username is mandatory with greater than 6 characters',
  'privateKey': 'Private Key is mandatory',
  'fullname': 'Fullname is mandatory',
  'general': 'This field is mandatory',
  'add_comment_mandatory': 'Comment is mandatory',
  'mandatory': 'Can not be empty',
};

Map<String, String> alertDialog = {
  'relax': 'Relax',
  'rerouteLoginPage': 'Redirecting to login page',
  'oops': 'Oops',
  'commonError': 'Something went wrong',
  'commonSuccess': 'Success',
  "registered": "Registered successfully",
  "usernameTaken": "Username already taken",
  "notRegistered": "User not registered",
  "invalidAuth": "Private key is not correct",
  "logoutSuccess": "User logged out successfully",
  "deactivationSuccess": "User successfully deactivated",
  "deactivationError": "Error while deactivating user",
  "addCommentSuccess": "Comment added successfully",
  "addNoteSuccess": "Note added successfully",
  "updateNoteSuccess": "Note updated successfully",
  "deleteNoteSuccess": "Note deleted successfully",
  "savedForLater": "Note saved for later",
  "noteAlreadySaved": "Note saved already",
  "savedNoteRemoved": "Note unsaved",
  "invalidBook": "Select the book from suggestion",
  "deleteCommentSuccess": "Comment deleted successfully",
};
