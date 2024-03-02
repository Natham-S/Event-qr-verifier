import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraControlButton extends StatelessWidget{
  const CameraControlButton({super.key, required this.onPressed, required this.isCameraPaused});

  final VoidCallback onPressed;
  final bool isCameraPaused;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isCameraPaused ? Colors.green : Colors.red,
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          CircleBorder(),
        ),
      ),
      child: Icon(
        isCameraPaused ? Icons.play_arrow : Icons.pause,
        color: Colors.white,
        size: 32.0,

      ),
    );
  }

}