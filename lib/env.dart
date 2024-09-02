import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'CLIENT_KEY', obfuscate: true)
  static final String clientKey = _Env.clientKey;

  @EnviedField(varName: 'APP_ID', obfuscate: true)
  static final String appId = _Env.appId;

  @EnviedField(varName: 'API_URL', obfuscate: true)
  static final String url = _Env.url;
}
