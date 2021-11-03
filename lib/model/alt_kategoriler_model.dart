class AltKategoriler {
  final int Id;
  final String KategoriAdi;
  final String Image;

  AltKategoriler({required this.Id, required this.KategoriAdi, required this.Image});

  factory AltKategoriler.fromJson(Map<String, dynamic> json) {
    return AltKategoriler(
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