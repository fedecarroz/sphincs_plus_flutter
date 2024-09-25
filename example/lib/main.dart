import 'package:flutter/material.dart';
import 'package:sphincs_plus/sphincs_plus_dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final sphincsPlus = SphincsPlus();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SPHINCS PLUS'),
          backgroundColor: Colors.amber,
        ),
        body: SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Parameters: ${sphincsPlus.params.toString()}'),
                const SizedBox(height: 5),
                Text('PK length: ${sphincsPlus.pkLength}'),
                const SizedBox(height: 5),
                Text('SK length: ${sphincsPlus.skLength}'),
                const SizedBox(height: 5),
                Text('Seed length: ${sphincsPlus.seedLength}'),
                const SizedBox(height: 5),
                Text('Signature length: ${sphincsPlus.signatureLength}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
