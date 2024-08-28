import 'package:flutter/material.dart';
import 'package:sphincs_plus/params.dart';

import 'package:sphincs_plus/sphincs_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final sphincsPlus = SphincsPlus(params: Params.haraka_128f);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SPHINCS PLUS'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }
}
