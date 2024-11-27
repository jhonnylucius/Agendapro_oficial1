import 'package:agendapro/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

/// Valida se o nome contém apenas letras e espaços.
String? validateName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);

  if (value?.isEmpty ?? true) {
    return "Nome é obrigatório";
  } else if (!regExp.hasMatch(value ?? '')) {
    return "O nome deve conter apenas letras e espaços";
  }
  return null;
}

/// Valida se o número de telefone é válido.
String? validateMobile(String? value) {
  String pattern = r'(^\+?[0-9]*$)';
  RegExp regExp = RegExp(pattern);

  if (value?.isEmpty ?? true) {
    return "Número de telefone é obrigatório";
  } else if (!regExp.hasMatch(value ?? '')) {
    return "O número de telefone deve conter apenas dígitos";
  }
  return null;
}

/// Valida se a senha possui no mínimo 6 caracteres.
String? validatePassword(String? value) {
  if ((value?.length ?? 0) < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  }
  return null;
}

/// Valida se o e-mail possui um formato válido.
String? validateEmail(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(value ?? '')) {
    return 'Insira um e-mail válido';
  }
  return null;
}

/// Valida se a senha e a confirmação coincidem.
String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (password != confirmPassword) {
    return 'As senhas não coincidem';
  } else if (confirmPassword?.isEmpty ?? true) {
    return 'A confirmação de senha é obrigatória';
  }
  return null;
}

/// Variável global para gerenciar o progresso.
late ProgressDialog progressDialog;

/// Exibe um diálogo de progresso.
Future<void> showProgress(
    BuildContext context, String message, bool isDismissible) async {
  progressDialog = ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: isDismissible);
  progressDialog.style(
    message: message,
    borderRadius: 10.0,
    backgroundColor: const Color(colorPrimary),
    progressWidget: Container(
      padding: const EdgeInsets.all(8.0),
      child: const CircularProgressIndicator(
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

/// Atualiza a mensagem do diálogo de progresso.
void updateProgress(String message) {
  progressDialog.update(message: message);
}

/// Oculta o diálogo de progresso.
Future<void> hideProgress() async {
  await progressDialog.hide();
}

/// Exibe um alerta com título e mensagem.
void showAlertDialog(BuildContext context, String title, String content) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [okButton],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Substitui a rota atual pela rota de destino.
void pushReplacement(BuildContext context, Widget destination) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => destination));
}

/// Adiciona uma nova rota na pilha de navegação.
void push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => destination));
}

/// Remove todas as rotas até a condição fornecida e adiciona uma nova.
void pushAndRemoveUntil(BuildContext context, Widget destination,
    bool Function(Route<dynamic>) predict) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => destination),
    predict,
  );
}

/// Exibe uma imagem circular a partir de uma URL.
Widget displayCircleImage(String picUrl, double size, bool hasBorder) =>
    CachedNetworkImage(
      imageBuilder: (context, imageProvider) =>
          _getCircularImageProvider(imageProvider, size, hasBorder),
      imageUrl: picUrl,
      placeholder: (context, url) =>
          _getPlaceholderOrErrorImage(size, hasBorder),
      errorWidget: (context, url, error) =>
          _getPlaceholderOrErrorImage(size, hasBorder),
    );

/// Retorna uma imagem de placeholder ou de erro.
Widget _getPlaceholderOrErrorImage(double size, bool hasBorder) => Container(
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

/// Retorna um widget com uma imagem circular a partir de um provedor.
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

/// Verifica se o modo escuro está ativado.
bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

/// Retorna o estilo de input decoration com base no tema.
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
      borderSide: BorderSide(color: errorColor),
      borderRadius: BorderRadius.circular(25.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorColor),
      borderRadius: BorderRadius.circular(25.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(25.0),
    ),
  );
}

/// Exibe uma mensagem como um Snackbar.
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
