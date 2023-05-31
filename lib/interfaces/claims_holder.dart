import 'claim.dart';

/// The [ClaimsHolder] class is just a wrapper for the map of claims
/// used for building a JWT.
abstract class ClaimsHolder
{
  final Map<String, Claim> _claims;

  const ClaimsHolder(this._claims);

  Map<String, Claim> get claims => _claims;
}
