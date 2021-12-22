import 'package:flutter/material.dart';
import 'package:phyllo_connect_example/constants/configs.dart';
import 'package:phyllo_connect_example/models/phyllo_args.dart';
import 'package:phyllo_connect_example/provider/pholly_provider.dart';
import 'package:phyllo_connect_example/views/widgets/app_button.dart';
import 'package:phyllo_connect_example/views/widgets/loader.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isChecked = false;

  void launchPhylloConnectSdk() {
    var phylloProvider = context.read<PhylloProvider>();

    PhylloArgs args = PhylloArgs(
      appName: 'Phyllo Connect Example',
      clientId: Configs.clientId,
      clientSecret: Configs.clientSecret,
      environment: Configs.env,
    );

    phylloProvider.launchPhylloConnectSdk(args);
  }        

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
                        onPressed: launchPhylloConnectSdk,
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        label: 'Connect Instagram using Phyllo',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        label: 'Connect YouTube using Phyllo',
                        onPressed: () {},
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
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 15,
            height: 15,
            child: Checkbox(
              value: isChecked,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          const Text('Existing user'),
        ],
      ),
    );
  }
}
