import 'dart:convert';

void main() {
  String transkripJson = '''
  {
    "nama": "Budi Martami",
    "NIM": "123456789",
    "mata_kuliah": [
      {
        "kode": "MK001",
        "nama": "Matematika Dasar",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "MK002",
        "nama": "Pemrograman Dasar",
        "sks": 4,
        "nilai": "B+"
      },
      {
        "kode": "MK003",
        "nama": "Basis Data",
        "sks": 3,
        "nilai": "A-"
      }
    ]
  }
  ''';

  Map<String, dynamic> transkrip = jsonDecode(transkripJson);

  List<Map<String, dynamic>> mataKuliah =
      List<Map<String, dynamic>>.from(transkrip['mata_kuliah']);

  double ipk = hitungIPK(mataKuliah);

  print('IPK: $ipk');
}

double hitungIPK(List<Map<String, dynamic>> mataKuliah) {
  double totalSKS = 0;
  double totalBobot = 0;

  for (var matkul in mataKuliah) {
    totalSKS += matkul['sks'];
    totalBobot += nilaiToBobot(matkul['nilai']) * matkul['sks'];
  }

  return totalBobot / totalSKS;
}

double nilaiToBobot(String nilai) {
  switch (nilai) {
    case 'A':
      return 4.0;
    case 'A-':
      return 3.7;
    case 'B+':
      return 3.3;
    default:
      return 0.0; 
  }
}
