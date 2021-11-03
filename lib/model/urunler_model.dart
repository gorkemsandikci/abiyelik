class Urun {
  final int Id;
  final int KategoriId;
  final String Name;
  final String Aciklama;
  final String Price;
  final String Image;

  Urun({required this.Id,required this.KategoriId, required this.Name,required this.Aciklama,required this.Price,required this.Image});

  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      Id: json['Id'],
      KategoriId: json['KategoriId'],
      Name: json['Name'],
      Aciklama: json['Aciklama'],
      Price: json['Price'],
      Image: json['Image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'KategoriId': KategoriId,
    'Name': Name,
    'Aciklama': Aciklama,
    'Price': Price,
    'Image': Image,
  };
}