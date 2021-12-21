import 'package:flutter/material.dart';
import 'package:phyllo_connect/phyllo_connect.dart';
import 'package:phyllo_connect_example/constants/app_colors.dart';
import 'package:phyllo_connect_example/constants/configs.dart';
import 'package:phyllo_connect_example/views/widgets/app_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isChecked = false;
  bool isLoading = false;

  PhylloConnect? phylloConnect;

  @override
  void initState() {
    super.initState();
    phylloConnect = PhylloConnect.getInstance(
      PhylloArgs(
        appName: 'Phyllo Connect Example',
        environment: Configs.env,
        clientId: Configs.clientId,
        clientSecret: Configs.clientSecret,
      ),
    );
  }

  void launchPhylloConnectSdk() async {
    try {
      setLoading(true);
      await phylloConnect!.launchPhylloConnectSdk();
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            if (isLoading)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              )
          ],
        ),
      ),
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
