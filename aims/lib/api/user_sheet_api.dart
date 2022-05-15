import 'package:aims/models/user_fields.dart';
import 'package:aims/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:gsheets/gsheets.dart';

class UserSheetApi {
  static const _credentials = r''' 
  {
  "type": "service_account",
  "project_id": "agriculture-info-manage-system",
  "private_key_id": "9c3ee1fe866727fca5c6255ecb4c766461241650",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9S7ODJJRUNpp4\noYPnM6v81XZlQugBytR7+8ieDbVKNTVhjUgjbAu5DiqhzO2ZBi7xat8tifrtlq5w\nkwPxcZAGVgKbhFuvGgP1MSXCdAZu1DhO8Ir6d9u76g9/9QIS3FPIpDrH+zqRi7gb\nIrpeJpGMxL2vTz3IgluZhXGDRguBWDGorlbP6E0ZtpuLOnB6rROsCny4qwXWOyvf\nJwt1HEW6BnyxsxLrxwz+TmyAS1VGpY7Jmw2oSmdWC66NeIswSUrsH1zLvaEULX1p\ngVOVSVzXgfENQe8vBfN7yerYJmip1UDVBNFHM8wnq5LI8dmDl5VOYhdzDvI3UdFB\noNKI7ZHPAgMBAAECggEADQRXo9Jay4ULD6CLttUReUwfMszBsjMwdBYsWty2dWk9\n8ny0qTrqKMpAmZUYrEfbPTQML3rS4TkAuzJg4wmGzei8OoAvjdWherWWfc4HYzeq\nEkOYSwD9qz5n3R9hX8qm4vU9gDhWdAvCQptwwBNcOZc4iVr5n1WCLFxwzIYp5GBT\nPvfWBbaViGXdRJfE3IPCTtC/HaVIjpoN2mr9CdqKLLw229T0O0LhEZAoCyxyRkWc\nN5iGzAYagb7bJLkK83B8ZnA109BKQW8KNenIKHrjmygcElUkXI9x6a5yk7jmpWnd\nytaZNG80bGoVLqy4M+eX7c2JIIrENONsOGL1j1jQAQKBgQDjl8KixpIXdwcyUUHQ\n5/bZrXu2GVgEYBgjsRHHtWjidadHQj8QoJ+jvpU1f3GYGgvD7Fhi8NGjAVk9YA4/\nJDqMYOR49r4meQri/36UgNGXpf5MRQQAghi8F+/fCxD0iUzx1BSnBER5eh0Fx0ZX\nMndToI3be339i180Lvzm7L9KgQKBgQDU7D039nFxYEu4AfDQtkYy4UzZMbTP28hY\ng1Fuy/6Yej0SvnXSt4Mc9Deb2dEZHoUMw9hrcVyGFNjKplxhJqyYR9zhySNWdLzA\n6VRaEPZTiyFgoRdhGN3aKpJ1G4EFVwkv1asp8A1rKdrOQEY7sSzqHtM8E4Usb4dN\nofyAO1OUTwKBgCgkMTESgtveo4dNa6VT9GbqQUKZ77s906Qf6/nkVi5y/+ECnyro\nmZ+A0sJPyxI/rcmNmv1AakksyLeZhInAcw8lW8a2Bk201aW52HKK0ezEWzjKh20r\nhP9P3X/ibMgkm0yf0lCu4QDn98x4HEDu5rr6O2r1ugAJH+6NRw/Xu9mBAoGBALJt\nEVP/MctnfaxB/BJ6XFMw19w+Oh3hOH9r8+acDcqqzNkTP9sHq1itEpiIrB+Xorky\nuP44bedyOsV/KXTEGug1eFTA39sIUlB6dxROmI0jzyGRfO0CEI9NE5QNK05VRD6Q\nmDG5lxURaulhlTlaXKAIms0CMpwtDb4xm0296WkjAoGAVheHSBIqEdrImuKt/B4b\njaWtxdnnBcauBxerzF7TLx6tz7yulbPHnTmVTWIcPMDP1tQGGXWUiyQHFW8ufUat\nctey2Q4Okc4noaS3vyoT9AohYC8ci0NBRHfDqP2Ugl/+AwkYjpauesZI2CzXy2sj\ndS/UHXqPZYvKEjxG8792npk=\n-----END PRIVATE KEY-----\n",
  "client_email": "googlesheet@agriculture-info-manage-system.iam.gserviceaccount.com",
  "client_id": "108873153229964065996",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/googlesheet%40agriculture-info-manage-system.iam.gserviceaccount.com"
}
  ''';
  static const _spreadsheetId = '1Ej5_oThzfptqIE1fQ4FUHVctYddge4T0BrXUoovYwDY';

  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _userSheet = await _getWorksheet(spreadsheet, title: 'Users');

      final firstRow = UserFields.getFields();
      _userSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<Worksheet> _getWorksheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static insertUser(UserModel userModel) {
    if (_userSheet == null) return;

    final row = UserFields.getFields();
    row[0] = userModel.firstName!;
    row[1] = userModel.secondName!;
    row[2] = userModel.role!;
    row[3] = userModel.email!;
    row[4] = userModel.uid!;
    _userSheet!.values.map.appendRow(row);
  }
}
