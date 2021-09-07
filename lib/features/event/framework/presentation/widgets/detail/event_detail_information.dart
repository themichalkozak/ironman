import 'package:flutter/material.dart';

class EventDetailInformationWidget extends StatelessWidget {
  final String information;

  const EventDetailInformationWidget({
    @required this.information,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Information: ',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(information ?? 'No information'),
            ),
          ],
        ),
      ),
    );
  }
}