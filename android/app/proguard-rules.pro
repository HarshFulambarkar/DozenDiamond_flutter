# --- Google Credentials API ---
-keep class com.google.android.gms.auth.api.credentials.** { *; }

# --- Google Pay Paisa API ---
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }

# --- Razorpay SDK ---
-keep class com.razorpay.** { *; }
-keepattributes *Annotation*

# --- Proguard annotations ---
-keep @interface proguard.annotation.Keep
-keep @interface proguard.annotation.KeepClassMembers

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.PaymentsClient
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.Wallet
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.WalletUtils
-dontwarn com.google.android.gms.auth.api.credentials.Credential$Builder
-dontwarn com.google.android.gms.auth.api.credentials.Credential
-dontwarn com.google.android.gms.auth.api.credentials.CredentialPickerConfig$Builder
-dontwarn com.google.android.gms.auth.api.credentials.CredentialPickerConfig
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequest$Builder
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequest
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequestResponse
-dontwarn com.google.android.gms.auth.api.credentials.Credentials
-dontwarn com.google.android.gms.auth.api.credentials.CredentialsClient
-dontwarn com.google.android.gms.auth.api.credentials.HintRequest$Builder
-dontwarn com.google.android.gms.auth.api.credentials.HintRequest
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers