class ErrorHandler {
  static String mapErrorMessage(String error) {
    if (error.contains('SocketException') || error.contains('Failed host lookup')) {
      return "Unable to connect. Please check your internet connection.";
    }
    if (error.contains('404')) {
      return "The requested audio file could not be found.";
    }
    if (error.contains('timeout')) {
      return "The connection timed out. Please try again.";
    }
    if (error.contains('No Internet Connection')) {
      return error; // Already friendly
    }
    
    // Generic fallback for technical errors
    if (error.startsWith('Error playing audio:')) {
      return "We encountered a problem playing this lesson. Please try again later.";
    }

    return error;
  }
}
