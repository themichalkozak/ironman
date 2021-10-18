import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReconnectBottomButton extends StatelessWidget {

  final Function callback;

  const ReconnectBottomButton({
    @required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    print('reconnected_bottom_button | build ()');
    return Container(
      height: 60,
      color: Colors.green,
      child: TextButton(
        onPressed: callback,
        child: Text('Press to search again',style: TextStyle(color: Colors.white,fontSize: 16),),
      ),
    );
  }
}