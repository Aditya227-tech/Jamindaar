# Stripe Push Provisioning (if used)
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider

# ProGuard annotations (safe to keep)
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers

-keep class io.flutter.plugins.firebase.messaging.** { *; } 