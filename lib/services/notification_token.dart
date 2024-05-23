import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async =>
      _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "wave-dev-42598",
          "private_key_id": "04a9c0140acc5b2b5dfe6919fd8fbad64f10d273",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCs6+2ppUi7iikj\niyW/L6CHujHuATOLl3jPuXQ7JmvKGanh7e+BG3u8hxxnLWt3N19B772A+A0zGDRp\nPsGzmlUDvn0rfS2j2R+TgdWQX/noP2rGXg9DvmkGLVSV5Dliq0qP6LxnhPL3tgqS\ns/KJHXddbGz8AR7ijPvbXBT6c5plLDDJS8NsA2zmvMUGcQSKcyD6xdfVKvFuyUhw\nETzx6va62ZCV9tQ/aQgbxiJCSmOuOgmShq0fvG20rK0fvpe52KmP7glgj7DQhLDT\n6+3+BbUkYvJ/Oj27FwONdRDPW4QgLbvg7c4M7rrR2CguBLODK1EFkEG/HMKKkseb\ntm3twUYLAgMBAAECggEAQ6SM1RprX7VVj2pcqzOxy7ZJ1s0QgVAQ+c0Vixfl/WpZ\nmqANWwdJuX9u3GuXiMyXzj6+didSXoTe57adZij+jZbj9vGiO2Bxai3VQYNRyoiY\nN53OwdTH15s+5d2flxnjcnT70lDfDIhhDW8n9nwY1+pUnaXAk6XL1czpBenX4TAo\nmQTAlRBbOb6vrOTNQ7+iq1DYen4r5nyEwbnR8dsXuRtqFK065BQns1ZLlkhiYGLq\nnJBUbTM/koNHOMGTHBF44p1GgNEe8oDf2HbiM2W6OKuipSnQrpVm12UvEJCZNODi\n3rPA7RKzbqK/123VrszqfdWJyNmSEE4md6kKNDZD/QKBgQDwYgbNuhnSgmvm4dVi\nGLPmzxkYc4ExtjcDMgP8mO441xux/VhlwsSb94FO1Ubn9ba+4wH4+l8jQV7PBC3G\nlS1eBnoX0m5QmfImdA+CjcwwcYL6/mP0P1/bSU10/q1/fMZsn14iCxgCOruYHkUv\nVoKBQX2+vBnkT/gmxP9UgSXXTwKBgQC4J+f9xTIU9MLFaZb+nMbRNfMy/kc9jMyx\n2ucBEjFdrgbiL2VShMe7+llB7CmglymYOvH2h+/ncF/1n7HAWIOumEZxOOVJ8txa\nD1k4V+pBU2hMnSrEpMf0P1dhhVIRBp8Ehtnnn7jtsPKq7nGfCjAFWNW8uwfAge4g\nYj8IKAZ2hQKBgQCls2ztM3PJYI3wwYvN6ylX2Tp7WGOeWPTjBv8oiGLuW5mDwBfH\nTdMpkBtatDoEe6RVQTaC4lPigZVRLpg/Y2W6gsx2z1+rv/Lj/u0SGZy/Z//Z9LIC\nFA2Ho6f5FfWTA/fjuJey7+LE5qeZ3IPkdcXQQ8ziRdezQkzUrMc1ATGMkQKBgCZ3\nJ20JWImqCljj0kdChgDDDRZ0qHrBwyvPNnsxyp/vrr5l+fr/gxzPkP9FDfjeOjDy\n9wFwqXqlLVYH0kAD/RVl9yjFIpeMo9wn4pHzQxn8CwgduAY1CRMKe/0BtP+ba3Gt\nnSxVX3I+iKGNhqwam6cyRArU4iyitxOKkfHpMlhlAoGBAICCiE9BD1VIhEwyrl4f\nv9W0DIYeBpCk84qin/NW7fC2Bqkc+knzHAytYu3QVgG1ekYjV9YOLeCL+Q5PdfeN\nHXfKZL8Yu9uN1MI1u9kETzThlII6buQneZtnxnsr5vSo+s7H6pp10yiqA11l1SkT\nBUYQmhrQuRHDivGy0E+QO0WJ\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-a77ia@wave-dev-42598.iam.gserviceaccount.com",
          "client_id": "117189559479665717716",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-a77ia%40wave-dev-42598.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      return null;
    }
  }
}
