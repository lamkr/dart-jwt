import 'package:dart_jwt/interfaces.dart';

/// Holds the payload claims when serializing a JWT.
class PayloadClaimsHolder extends ClaimsHolder {

  const PayloadClaimsHolder([Map<String, Claim> claims=const <String,Claim>{}])
    : super(claims);
}