import 'package:flutter/material.dart';

class ItemMenuButton extends StatelessWidget {
  const ItemMenuButton({
    @required this.onTap,
    @required this.title,
    @required this.icon,
  });

  final String title;
  final IconData icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        child: Container(
          height: MediaQuery.of(context).size.height / 3.9,
          width: MediaQuery.of(context).size.width / 2.8,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 8,
                margin: const EdgeInsets.only(bottom: 5),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Icon(icon, color: Colors.white, size: 50),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        onTap: onTap,
      );
}
