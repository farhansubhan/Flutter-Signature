import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:tandatangan/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.red,
    exportBackgroundColor: Colors.grey[300],
    exportPenColor: Colors.red,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data = await _controller.toPngBytes(
      height: 300,
      width: MediaQuery.of(context).size.width.toInt(),
    );
    if (data == null) {
      return;
    }

    if (!mounted) return;

    await push(
      context,
      Scaffold(
        appBar: AppBar(
          title: const Text('Preview'),
        ),
        body: Center(
          child: Container(
            color: Colors.grey[300],
            child: Image.memory(data),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signature'),
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Signature Here",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Signature(
            key: const Key('signature'),
            controller: _controller,
            height: 300,
            backgroundColor: Colors.grey[300]!,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionChip(
                  label: const Text("Clear", style: TextStyle(color: Colors.white),),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.red,
                  onPressed: () {
                    setState(() => _controller.clear());
                  }
                ),
                const SizedBox(
                  width: 10,
                ),
                ActionChip(
                  label: const Text("Save", style: TextStyle(color: Colors.white),),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.green,
                  onPressed: () => exportImage(context),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}