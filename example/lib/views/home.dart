import 'package:flutter/material.dart';
import 'package:phyllo_connect_example/pholly_provider.dart';
import 'package:phyllo_connect_example/views/app_button.dart';
import 'package:phyllo_connect_example/views/loader.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String instagramId = '9bb8913b-ddd9-430b-a66a-d74d846e6c66';
  static const String youtubeId = '14d9ddf5-51c6-415e-bde6-f8ed36ad7054';

  @override
  Widget build(BuildContext context) {
    return Consumer<PhylloProvider>(
      builder: (context, phylloProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Phyllo Connect Example'),
            elevation: 0,
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppButton(
                        label: 'Connect Platform Account(S)',
                        onPressed: () {
                          phylloProvider.launchSdk('');
                        },
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        label: 'Connect Instagram using Phyllo',
                        onPressed: () {
                          phylloProvider.launchSdk(instagramId);
                        },
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        label: 'Connect YouTube using Phyllo',
                        onPressed: () {
                          phylloProvider.launchSdk(youtubeId);
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildExistingUserCheckbox(),
                    ],
                  ),
                ),
                Loader.loadingWithBackground(phylloProvider.isLoading),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExistingUserCheckbox() {
    var phylloController = context.read<PhylloProvider>();
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 15,
            height: 15,
            child: Checkbox(
              value: phylloController.isExistingUser,
              activeColor: Colors.green,
              onChanged: phylloController.userId != null
                  ? phylloController.isExistingUserStatusChanged
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          const Text('Existing user'),
        ],
      ),
    );
  }
}
