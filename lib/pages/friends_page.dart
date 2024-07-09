import 'package:challengeone/pages/home_page.dart';
import 'package:flutter/material.dart';

class FriendsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTitle(
          title: '5명',
          subtitle: '친구들 중 1등이에요',
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/user2.jpg'),
          ),
          title: Text('신유'),
          subtitle: Text('챌린지 5개 성공'),
          trailing: Icon(Icons.check_circle, color: Colors.green),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/user3.jpg'),
          ),
          title: Text('도훈'),
          subtitle: Text('챌린지 3개 성공'),
          trailing: Icon(Icons.check_circle_outline),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/user4.jpg'),
          ),
          title: Text('영재'),
          subtitle: Text('챌린지 3개 성공'),
          trailing: Icon(Icons.check_circle_outline),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/user5.jpg'),
          ),
          title: Text('한진'),
          subtitle: Text('챌린지 3개 성공'),
          trailing: Icon(Icons.check_circle_outline),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/user6.jpg'),
          ),
          title: Text('경민'),
          subtitle: Text('챌린지 3개 성공'),
          trailing: Icon(Icons.check_circle_outline),
        ),
      ],
    );
  }
}
