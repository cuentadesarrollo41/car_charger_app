import 'dart:convert';
import 'dart:typed_data';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';

FileModel fileModelFromJson(String str) => FileModel.fromJson(json.decode(str));

String fileModelToJson(FileModel data) => json.encode(data.toJson());

class FileModel {
  String name;
  String url;
  Uint8List? bytes;
  bool callDeletion;

  FileModel({
    this.name = Strings.emptyString,
    this.url = Strings.emptyString,
    this.bytes,
    this.callDeletion = false,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
    name: json[Fields.name] ?? Strings.emptyString,
    url: json[Fields.url] ?? Strings.emptyString,
    bytes: json[Fields.bytes],
    callDeletion: json[Fields.callDeletion] ?? false,
  );

  Map<String, dynamic> toJson() => {
    Fields.name: name,
    Fields.url: url,
    Fields.bytes: bytes,
    Fields.callDeletion: callDeletion,
  };

  void setNameUrl(String name, String url) {
    this.name = name;
    this.url = url;
  }

  void setFromFile(FileModel file) {
    name = file.name;
    url = file.url;
    bytes = file.bytes;
    callDeletion = file.callDeletion;
  }

  bool isEmpty() => url.isEmpty && bytes == null;
}
