import 'dart:async';

import 'package:ebroker/ui/screens/widgets/interactive_property_map.dart';
import 'package:ebroker/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({
    required this.latitude,
    required this.longitude,
    required this.propertyType,
    super.key,
  });
  final double latitude;
  final double longitude;
  final String propertyType;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  bool isGoogleMapVisible = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      isGoogleMapVisible = true;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        isGoogleMapVisible = false;
        setState(() {});
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Builder(
        builder: (context) {
          if (!isGoogleMapVisible) {
            return Center(child: UiUtils.progress());
          }
          return InteractivePropertyMap(
            latitude: widget.latitude,
            longitude: widget.longitude,
            propertyType: widget.propertyType,
          );
        },
      ),
    );
  }
}
