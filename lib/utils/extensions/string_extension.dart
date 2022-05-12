extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String cutBlockChainAddress() {
    if(length > 20) {
      return '${substring(0, 10)}...${substring(length - 10)}';
    }
    return this;
  }


  bool isValidEmail(){
    final RegExp _emailRegExp = RegExp('[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}');
    return _emailRegExp.hasMatch(this);
  }

  bool isValidPhoneNumber() {
    if(startsWith('0') && length < 10) {
      return false;
    }
    // Minimum eight and maximum 9 numbers
    final RegExp _phoneNumberRegExp = RegExp(r'^(?=.*?[0-9]).{9,10}$');
    return _phoneNumberRegExp.hasMatch(this);
  }

  bool isValidPassword() {
    // Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character
    final RegExp _passwordRegExp = RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@\$%^&*-]).{8,}\$');
    return _passwordRegExp.hasMatch(this);
  }

  bool equalsIgnoreCase(String string1) {
    return toLowerCase() == string1.toLowerCase();
  }
}
