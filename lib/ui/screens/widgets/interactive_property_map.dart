import 'package:ebroker/exports/main_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class InteractivePropertyMap extends StatefulWidget {
  const InteractivePropertyMap({
    required this.latitude,
    required this.longitude,
    required this.propertyType,
    this.onFullScreenTap,
    super.key,
  });

  final double latitude;
  final double longitude;
  final String propertyType;
  final VoidCallback? onFullScreenTap;

  @override
  State<InteractivePropertyMap> createState() => _InteractivePropertyMapState();
}

class _InteractivePropertyMapState extends State<InteractivePropertyMap> {
  final Completer<GoogleMapController> _controller = Completer();
  late String _darkMapStyle;
  bool _isStyleLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _loadMapStyle();
    });
  }

  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString(
      'assets/map_styles/dark_map.json',
    );
    _isStyleLoaded = true;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isStyleLoaded) {
      return Center(child: UiUtils.progress());
    }

    final latLng = LatLng(widget.latitude, widget.longitude);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: latLng,
              zoom: 12,
            ),
            onMapCreated: (controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            style: context.color.brightness == Brightness.dark
                ? _darkMapStyle
                : null,
            circles: {
              Circle(
                circleId: const CircleId('property_radius'),
                center: latLng,
                radius: 5000, // 5km in meters
                fillColor: context.color.tertiaryColor.withValues(alpha: .3),
                strokeWidth: 2,
                strokeColor: context.color.tertiaryColor,
              ),
            },
            gestureRecognizers: const {
              Factory<OneSequenceGestureRecognizer>(
                EagerGestureRecognizer.new,
              ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
        ),
        if (widget.onFullScreenTap != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: widget.onFullScreenTap,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.color.secondaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.fullscreen,
                  color: context.color.textColorDark,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
