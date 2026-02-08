import 'package:ebroker/exports/main_export.dart';

class FlutterwaveRepository {
  Future<String> fetchFlutterwaveLink({
    required int packageId,
  }) async {
    try {
      final response = await Api.post(
        url: Api.flutterwave,
        parameter: {'package_id': packageId},
      );

      if (response['error'] == false && response['data'] != null) {
        return response['data']['data']['link']?.toString() ?? '';
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch flutterwave link',
        );
      }
    } on Exception catch (e) {
      throw Exception('Failed to get flutterwave url: $e');
    }
  }
}
