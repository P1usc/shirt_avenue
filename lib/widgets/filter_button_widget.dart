import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Larghezza fissa per tutti i pulsanti
      height: 40, // Altezza fissa per tutti i pulsanti
      decoration: BoxDecoration(
        color: isActive
            ? Colors.orange
            : Colors.grey[300], // Colore in base allo stato
        borderRadius: BorderRadius.circular(10), // Bordi meno arrotondati
      ),
      child: TextButton(
        onPressed: onPressed, // Callback per il pulsante
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0), // Rimuove il padding interno
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Bordi meno arrotondati
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : Colors.black, // Colore del testo in base allo stato
            fontSize: 14, // Dimensione del testo
          ),
        ),
      ),
    );
  }
}
