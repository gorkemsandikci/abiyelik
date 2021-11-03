class Student {
  final int Id;
  final String KategoriAdi;
  final String Image;

  Student({required this.Id, required this.KategoriAdi,required this.Image});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      Id: json['Id'],
      KategoriAdi: json['KategoriAdi'],
      Image: json['Image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'KategoriAdi': KategoriAdi,
    'Image': Image,
  };
}