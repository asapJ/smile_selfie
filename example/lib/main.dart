import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smile_selfie/smile_selfie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SmileSelfie.initialize();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Selfie Test',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _path = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await SmileSelfie.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smile Selfie Demo'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () async {
                  const options = SmileSelfieOptions(
                      eyesOpenProbabilty: 0.5, //between 0.0 to 1
                      smileProbability: 0.5, //between 0.0 to 1,
                      delay: Duration(seconds: 5));

                  final decoration = SmileSelfieDecoration(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      footer: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: const [
                            Text(
                              'Powered by Google ML Kit',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      header: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            "Smile to take a selfie",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      previewSize: 400);
                  String path = await SmileSelfie.captureSelfie(context,
                      smileSelfieOptions: options,
                      selfieDecoration: decoration);
                  setState(() {
                    _path = path;
                  });
                },
                child: const Text("Start Selfie Capture")),
            const SizedBox(
              height: 40,
            ),
            Text('Selfie Path : $_path')
          ],
        ),
      ),
    );
  }
}
