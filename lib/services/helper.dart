import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/constants.dart';
import 'package:progress_dialog/progress_dialog.dart';

/// Validators
String? validateName(String? value) {
  if (value?.isEmpty ?? true) {
    return "Name is required";
  }
  final pattern = RegExp(r'(^[a-zA-Z ]*$)');
  if (!pattern.hasMatch(value!)) {
    return "Name must contain only letters and spaces";
  }
  return null;
}

String? validateMobile(String? value) {
  if (value?.isEmpty ?? true) {
    return "Mobile phone number is required";
  }
  final pattern = RegExp(r'(^\+?[0-9]*$)');
  if (!pattern.hasMatch(value!)) {
    return "Mobile phone number must contain only digits";
  }
  return null;
}

String? validatePassword(String? value) {
  if ((value?.length ?? 0) < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validateEmail(String? value) {
  final pattern = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (!(pattern.hasMatch(value ?? ''))) {
    return 'Enter a valid email';
  }
  return null;
}

String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (password != confirmPassword) {
    return 'Passwords do not match';
  }
  if (confirmPassword?.isEmpty ?? true) {
    return 'Confirm password is required';
  }
  return null;
}

/// Progress Dialog
late ProgressDialog progressDialog;

Future<void> showProgress(
    BuildContext context, String message, bool isDismissible) async {
  progressDialog = ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: isDismissible);
  progressDialog.style(
    message: message,
    borderRadius: 10.0,
    backgroundColor: const Color(colorPrimary),
    progressWidget: const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation(Color(colorPrimary)),
      ),
    ),
    elevation: 10.0,
    insetAnimCurve: Curves.easeInOut,
    messageTextStyle: const TextStyle(
        color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
  );
  await progressDialog.show();
}

void updateProgress(String message) {
  progressDialog.update(message: message);
}

Future<void> hideProgress() async {
  await progressDialog.hide();
}

/// Alert Dialog
void showAlertDialog(BuildContext context, String title, String content) {
  final okButton = TextButton(
    child: const Text("OK"),
    onPressed: () => Navigator.pop(context),
  );

  final alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [okButton],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) => alert,
  );
}

/// Navigation Helpers
void pushReplacement(BuildContext context, Widget destination) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => destination));
}

void push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => destination));
}

void pushAndRemoveUntil(
    BuildContext context, Widget destination, bool Function(Route) predicate) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => destination),
    predicate,
  );
}

/// Image Helpers
Widget displayCircleImage(String picUrl, double size, bool hasBorder) {
  return CachedNetworkImage(
    imageBuilder: (context, imageProvider) =>
        _getCircularImageProvider(imageProvider, size, hasBorder),
    imageUrl: picUrl,
    placeholder: (context, url) => _getPlaceholderOrErrorImage(size, hasBorder),
    errorWidget: (context, url, error) =>
        _getPlaceholderOrErrorImage(size, hasBorder),
  );
}

Widget _getPlaceholderOrErrorImage(double size, bool hasBorder) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xff7c94b6),
      borderRadius: BorderRadius.all(Radius.circular(size / 2)),
      border: Border.all(
        color: Colors.white,
        width: hasBorder ? 2.0 : 0.0,
      ),
    ),
    child: ClipOval(
      child: Image.asset(
        'assets/images/placeholder.jpg',
        fit: BoxFit.cover,
        height: size,
        width: size,
      ),
    ),
  );
}

Widget _getCircularImageProvider(
    ImageProvider provider, double size, bool hasBorder) {
  return ClipOval(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
        border: Border.all(
          color: Colors.white,
          style: hasBorder ? BorderStyle.solid : BorderStyle.none,
          width: 1.0,
        ),
        image: DecorationImage(image: provider, fit: BoxFit.cover),
      ),
    ),
  );
}

/// Theme Helpers
bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

InputDecoration getInputDecoration({
  required String hint,
  required bool darkMode,
  required Color errorColor,
}) {
  return InputDecoration(
    constraints: const BoxConstraints(maxWidth: 720, minWidth: 200),
    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    fillColor: darkMode ? Colors.black54 : Colors.white,
    hintText: hint,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(color: Color(colorPrimary), width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: errorColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: errorColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
  );
}

/// SnackBar Helper
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
