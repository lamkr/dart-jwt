import 'package:dart_jwt/interfaces.dart';

/// Holds the header claims when serializing a JWT.
class HeaderClaimsHolder extends ClaimsHolder {

  const HeaderClaimsHolder(Map<String, Claim> claims)
    : super(claims);
}