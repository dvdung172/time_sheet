import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class DashBoardTab extends StatelessWidget {
  const DashBoardTab({Key? key}) : super(key: key);
  static final _titleList = [
    'Today',
    'This Week',
    'This Month',
    'Last Month',
    'This Year',
    'Total',
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          children: List.generate(6, (index) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(_titleList[index],
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const Divider( thickness: 1,),
                  const Text('37h25m'),
                  Text('\$20000', style: CustomTheme.mainTheme.textTheme.headline1)
                ]
            );
          }),
        );
  }
}