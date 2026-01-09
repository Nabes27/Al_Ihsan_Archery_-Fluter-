import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static final UserData _instance = UserData._internal();
  
  factory UserData() {
    return _instance;
  }
  
  UserData._internal();

  String namaLengkap = '';
  String namaPengguna = '';
  String email = '';
  String nomorTelepon = '';
  String tanggalLahir = '';
  String kategori = '';
  String password = '';

  // Load data from SharedPreferences
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    namaLengkap = prefs.getString('namaLengkap') ?? '';
    namaPengguna = prefs.getString('namaPengguna') ?? '';
    email = prefs.getString('email') ?? '';
    nomorTelepon = prefs.getString('nomorTelepon') ?? '';
    tanggalLahir = prefs.getString('tanggalLahir') ?? '';
    kategori = prefs.getString('kategori') ?? '';
    password = prefs.getString('password') ?? '';
  }

  // Save data to SharedPreferences
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('namaLengkap', namaLengkap);
    await prefs.setString('namaPengguna', namaPengguna);
    await prefs.setString('email', email);
    await prefs.setString('nomorTelepon', nomorTelepon);
    await prefs.setString('tanggalLahir', tanggalLahir);
    await prefs.setString('kategori', kategori);
    await prefs.setString('password', password);
  }

  // Calculate kategori based on tanggal lahir
  String calculateKategori(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year - 
                ((now.month > birthDate.month || 
                  (now.month == birthDate.month && now.day >= birthDate.day)) 
                  ? 0 : 1);

    if (age < 9) {
      return 'U9';
    } else if (age < 12) {
      return 'U12';
    } else if (age < 15) {
      return 'U15';
    } else {
      return 'Dewasa';
    }
  }

  Future<void> clearData() async {
    namaLengkap = '';
    namaPengguna = '';
    email = '';
    nomorTelepon = '';
    tanggalLahir = '';
    kategori = '';
    password = '';
    
    // Clear from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
