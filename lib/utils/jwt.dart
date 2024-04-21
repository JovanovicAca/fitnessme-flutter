import 'package:jwt_decode/jwt_decode.dart';

String getUserIdFromToken(String? token) {
  if (token == null || token.isEmpty) {
    throw Exception("Token is null or empty");
  }
  try {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    String userId = decodedToken['Id'];
    return userId;
  } catch (e) {
    throw Exception("Failed to decode token: $e");
  }
}

String getUserRoleFromToken(String? token) {
  if (token == null || token.isEmpty) {
    throw Exception("Token is null or empty");
  }
  try {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    print("TOKEN " + decodedToken['Email']);
    String userRole = decodedToken['Role'];
    return userRole;
  } catch (e) {
    throw Exception("Failed to decode token: $e");
  }
}
