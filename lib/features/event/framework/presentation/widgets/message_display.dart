import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final String assetPath;

  const MessageDisplay({Key key, @required this.message, this.assetPath})
      : assert(message != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            assetPath != null ? Image.asset(assetPath,width: 90,errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
              return Image.asset(assetPath,width: 90);
            },) : SizedBox(),
            Text(
              message,
              style: TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
