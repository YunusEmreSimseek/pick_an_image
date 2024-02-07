import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pick_an_image/mixins/life_cycle_manage_mixin.dart';
import 'package:pick_an_image/services/pick_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver, LifeCyleUse {
  static const String _appBarTitle = 'Image Picker Example';
  static const String _buttonTitle = 'Pick An Image';
  final IPickManager _pickManager = PickManager();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_appBarTitle),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () async {
                    final model = await _pickManager.fetchMediaImage();
                    setState(() {
                      image = model?.file;
                    });
                  },
                  icon: const Icon(Icons.library_add),
                  label: const Text(_buttonTitle)),
              _ShowPickedImageWithFutureBuilder(image: image),
            ]),
      ),
    );
  }

  @override
  void onResume() {}
}

class _ShowPickedImageWithFutureBuilder extends StatelessWidget {
  const _ShowPickedImageWithFutureBuilder({
    required this.image,
  });

  final XFile? image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .6,
      child: FutureBuilder(
        future: image?.readAsBytes(),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height * .6,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
