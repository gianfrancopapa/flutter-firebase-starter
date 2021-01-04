import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/app_data.dart';
import 'package:flutterBoilerplate/constants/strings.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppString.configuration,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[500],
      ),
      bottomNavigationBar: BottomAppBar(
        child: ListTile(
          enabled: false,
          title: Text(AppString.version),
          trailing: FutureBuilder(
            future: AppData().getVersionNumber(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                Text(
              snapshot.hasData ? snapshot.data : 'Loading ...',
              style: const TextStyle(color: Colors.black38),
            ),
          ),
        ),
      ),
    );
  }
}
