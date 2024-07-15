import 'package:flutter/material.dart';

import 'auth_card.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://www.elleman.vn/app/uploads/2021/05/14/193809/featured-elle-style-calendar-hoa-tiet-nhiet-doi-0421-elleman-x.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 26, 41, 51).withOpacity(0.5),
            ),
          ),
          const AuthCard(),
        ],
      ),
    );
  }
}
