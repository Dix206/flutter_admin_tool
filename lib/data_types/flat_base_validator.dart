class FlatBaseValidator {
  static bool isEmail(String? email) {
    if (email == null) return false;
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9_-]+\.[a-zA-Z]+").hasMatch(email);
  }

  static bool isPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null) return false;
    return RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)').hasMatch(phoneNumber);
  }

  static bool isPrice(double? price) {
    if (price == null) return false;
    return RegExp(r"^[0-9]+(\.[0-9]{1,2})?$").hasMatch(price.toString());
  }
}
