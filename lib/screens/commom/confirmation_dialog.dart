import 'package:flutter/material.dart';

Future<dynamic> showConfirmationDialog(
  BuildContext context, {
  String title = "Atenção",
  String content = "Voce deja realmente executar essa operação?",
  String confirmButtonText = "Sim",
  String cancelButtonText = "Não",
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context, false);
              }, child: const Text("Cancelar")),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  confirmButtonText.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]);
      });
}
