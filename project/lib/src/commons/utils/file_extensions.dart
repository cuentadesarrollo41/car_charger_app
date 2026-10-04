class FileExtensions {
  static const String bin = 'bin';
  static const String doc = 'doc';
  static const String docx = 'docx';
  static const String docxExtension = 'vnd.openxmlformats-officedocument.wordprocessingml.document';
  static const String jpeg = 'jpeg';
  static const String jpg = 'jpg';
  static const String msword = 'msword';
  static const String pdf = 'pdf';
  static const String png = 'png';
  static const String svg = 'svg';
  static const String zip = 'zip';

  // Get extension from content type.
  static String inferExtension(String contentType) {
    if (contentType.contains(pdf)) return pdf;
    if (contentType.contains(zip)) return zip;
    if (contentType.contains(png)) return png;
    if (contentType.contains(jpeg) || contentType.contains(jpg)) return jpg;
    if (contentType.contains(msword)) return doc;
    if (contentType.contains(docxExtension)) return docx;

    return bin;
  }
}