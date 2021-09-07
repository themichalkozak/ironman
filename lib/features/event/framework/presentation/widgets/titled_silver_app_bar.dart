import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitledSilverAppBar extends StatelessWidget {
  final String title;

  const TitledSilverAppBar({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: 120,
      centerTitle: true,
      flexibleSpace: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(title,style: TextStyle(color: Colors.white,fontSize: 32,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}