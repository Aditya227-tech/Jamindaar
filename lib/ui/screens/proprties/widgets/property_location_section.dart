import 'package:ebroker/exports/main_export.dart';
import 'package:ebroker/ui/screens/proprties/widgets/google_map_screen.dart';
import 'package:ebroker/ui/screens/widgets/interactive_property_map.dart';
import 'package:flutter/material.dart';

class PropertyLocationSection extends StatelessWidget {
  const PropertyLocationSection({
    required this.property,
    super.key,
  });
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.color.secondaryColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: context.color.borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          CustomText(
            'locationLbl'.translate(context),
            fontWeight: .w600,
            fontSize: context.font.md,
            color: context.color.textColorDark,
          ),
          const SizedBox(height: 8),
          UiUtils.getDivider(context),
          const SizedBox(height: 8),
          _buildAddressSection(context),
          const SizedBox(height: 8),
          _buildMapContainer(context),
        ],
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    return CustomText(
      '',
      isRichText: true,
      maxLines: 6,
      textSpan: TextSpan(
        children: [
          TextSpan(
            text: "${"addressLbl".translate(context)}: ",
            style: TextStyle(
              fontSize: context.font.sm,
              color: context.color.inverseSurface,
              fontWeight: .w500,
            ),
          ),
          TextSpan(
            text: property.address ?? '',
            style: TextStyle(
              fontSize: context.font.sm,
              color: context.color.textColorDark,
              fontWeight: .w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapContainer(BuildContext context) {
    return SizedBox(
      height: 168.rh(context),
      child: InteractivePropertyMap(
        latitude: double.parse(property.latitude ?? '0'),
        longitude: double.parse(property.longitude ?? '0'),
        propertyType: property.propertyType ?? '',
        onFullScreenTap: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute<dynamic>(
              builder: (context) {
                return Scaffold(
                  extendBodyBehindAppBar: true,
                  backgroundColor: context.color.primaryColor,
                  appBar: AppBar(
                    elevation: 0,
                    iconTheme: IconThemeData(
                      color: context.color.tertiaryColor,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  body: GoogleMapScreen(
                    latitude: double.parse(property.latitude ?? '0'),
                    longitude: double.parse(property.longitude ?? '0'),
                    propertyType: property.propertyType ?? '',
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
