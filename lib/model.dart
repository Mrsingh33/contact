import 'dart:convert';

Mynumber mynumberFromJson(String str) => Mynumber.fromJson(json.decode(str));

String mynumberToJson(Mynumber data) => json.encode(data.toJson());


class Mynumber {
  Mynumber({
    this.id,
    this.number,
  });

  String id;
  String number;

  factory Mynumber.fromJson(Map<String, dynamic> json) => Mynumber(
    id: json["id"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "number": number,
  };
}
