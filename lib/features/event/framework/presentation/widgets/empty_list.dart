import 'package:flutter/cupertino.dart';

class EmptyList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(image: AssetImage('assets/images/empty_list.png')),
        Text('Events not found',style: TextStyle(fontWeight: FontWeight.bold),)
      ],
    );
  }
}