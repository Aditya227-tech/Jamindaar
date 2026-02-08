import 'package:ebroker/data/model/subscription_pacakage_model.dart';
import 'package:ebroker/exports/main_export.dart';

import 'package:ebroker/utils/payment/payment_gateway_manager.dart';

class PaymentManager {
  PaymentManager();

  Future<void> pay({
    required BuildContext context,
    required SubscriptionPackageModel package,
    required String gatewayKey,
  }) async {
    // if (Platform.isIOS) return; // Should be handled by UI using InAppPurchaseManager

    await PaymentGatewayManager().pay(
      context: context,
      package: package,
      paymentMethod: gatewayKey,
    );
  }
}
