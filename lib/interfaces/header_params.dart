/// Contains constants representing the JWT header parameter names.
class HeaderParams
{
    HeaderParams._();

    /// The algorithm used to sign a JWT.
    static const algorithm = "alg";

    /// The content type of the JWT.
    static const contentType = "cty";

    /// The media type of the JWT.
    static const type = "typ";

    /// The key ID of a JWT used to specify the key for signature validation.
    static const keyId = "kid";
}
