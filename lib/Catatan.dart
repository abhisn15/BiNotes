class Catatan {
  final int id;
  final String judul;
  final String isi;
  final String waktu;

  Catatan(
      {required this.id,
      required this.judul,
      required this.isi,
      required this.waktu});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'waktu': waktu,
    };
  }
}
