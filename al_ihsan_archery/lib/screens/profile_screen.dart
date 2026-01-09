import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'upload_kta_screen.dart';
import 'kta_card_screen.dart';
import 'dashboard_non_member.dart';
import 'archer_scoring_screen.dart';
import 'setup_training_screen.dart';
import 'login_screen.dart';
import '../utils/user_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaLengkapController;
  late final TextEditingController _namaPenggunaController;
  late final TextEditingController _emailController;
  late final TextEditingController _noTeleponController;
  late final TextEditingController _tanggalLahirController;
  late final TextEditingController _kategoriController;
  final _passwordLamaController = TextEditingController();
  final _passwordBaruController = TextEditingController();
  bool _isEditing = false;
  bool _isChangingPassword = false;
  bool _obscurePasswordLama = true;
  bool _obscurePasswordBaru = true;
  bool _isMember = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = UserData();
    await userData.loadData();
    
    setState(() {
      _namaLengkapController = TextEditingController(text: userData.namaLengkap);
      _namaPenggunaController = TextEditingController(text: userData.namaPengguna);
      _emailController = TextEditingController(text: userData.email);
      _noTeleponController = TextEditingController(text: userData.nomorTelepon);
      _tanggalLahirController = TextEditingController(text: userData.tanggalLahir);
      _kategoriController = TextEditingController(text: userData.kategori);
      _isMember = userData.isMember;
    });
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _namaPenggunaController.dispose();
    _emailController.dispose();
    _noTeleponController.dispose();
    _tanggalLahirController.dispose();
    _kategoriController.dispose();
    _passwordLamaController.dispose();
    _passwordBaruController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final userData = UserData();
      userData.namaLengkap = _namaLengkapController.text;
      userData.namaPengguna = _namaPenggunaController.text;
      userData.email = _emailController.text;
      userData.nomorTelepon = _noTeleponController.text;
      
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil disimpan!'),
          backgroundColor: Color(0xFF10B982),
        ),
      );
    }
  }

  void _changePassword() async {
    if (_passwordLamaController.text.isEmpty || _passwordBaruController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password lama dan baru harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userData = UserData();
    if (_passwordLamaController.text != userData.password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password lama tidak sesuai!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordBaruController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password baru minimal 8 karakter!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    userData.password = _passwordBaruController.text;
    await userData.saveData(); // Save to SharedPreferences
    
    setState(() {
      _isChangingPassword = false;
      _passwordLamaController.clear();
      _passwordBaruController.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password berhasil diubah!'),
        backgroundColor: Color(0xFF10B982),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Jangan hapus data user, hanya navigasi ke login screen
              // Data user tetap tersimpan untuk login berikutnya
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF10B982), width: 3),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Color(0xFF10B982),
                  ),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur upload foto akan segera hadir!'),
                            backgroundColor: Color(0xFF10B982),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B982),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            // Profile Form
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      label: 'Nama Lengkap',
                      controller: _namaLengkapController,
                      enabled: _isEditing,
                      hint: 'Masukkan nama lengkap',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Nama Pengguna',
                      controller: _namaPenggunaController,
                      enabled: _isEditing,
                      hint: 'Masukkan nama pengguna',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      enabled: _isEditing,
                      hint: 'Masukkan email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'No Telepon',
                      controller: _noTeleponController,
                      enabled: _isEditing,
                      hint: 'Masukkan nomor telepon',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Tanggal Lahir',
                      controller: _tanggalLahirController,
                      enabled: false,
                      hint: 'Tanggal lahir',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Kategori',
                      controller: _kategoriController,
                      enabled: false,
                      hint: 'Kategori',
                    ),
                    const SizedBox(height: 24),
                    // Edit/Save Button
                    ElevatedButton(
                      onPressed: () {
                        if (_isEditing) {
                          _saveProfile();
                        } else {
                          setState(() {
                            _isEditing = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B982),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _isEditing ? 'Simpan Profil' : 'Edit Profile',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Change Password Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ganti Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Switch(
                        value: _isChangingPassword,
                        onChanged: (value) {
                          setState(() {
                            _isChangingPassword = value;
                            if (!value) {
                              _passwordLamaController.clear();
                              _passwordBaruController.clear();
                            }
                          });
                        },
                        activeColor: const Color(0xFF10B982),
                      ),
                    ],
                  ),
                  if (_isChangingPassword) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Password Lama',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordLamaController,
                      obscureText: _obscurePasswordLama,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password lama',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF10B982)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF10B982)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF10B982), width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePasswordLama ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePasswordLama = !_obscurePasswordLama;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Password Baru',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordBaruController,
                      obscureText: _obscurePasswordBaru,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password baru (min 8 karakter)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF10B982)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF10B982)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF10B982), width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePasswordBaru ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePasswordBaru = !_obscurePasswordBaru;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B982),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Ubah Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Demo: Member Toggle Switch
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFF59E0B),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.science,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Mode Demo',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isMember ? 'Status: Member' : 'Status: Non-Member',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                      Switch(
                        value: _isMember,
                        onChanged: (value) async {
                          setState(() {
                            _isMember = value;
                          });
                          final userData = UserData();
                          userData.isMember = value;
                          if (value) {
                            // Auto-generate membership when toggled to member
                            userData.ktaStatus = 'approved';
                            final now = DateTime.now();
                            final random = now.millisecondsSinceEpoch % 10000;
                            userData.membershipNumber = 'AIA-${now.year}-${random.toString().padLeft(4, '0')}';
                            userData.membershipValidFrom = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
                            final validUntil = DateTime(now.year + 2, now.month, now.day);
                            userData.membershipValidUntil = '${validUntil.day.toString().padLeft(2, '0')}/${validUntil.month.toString().padLeft(2, '0')}/${validUntil.year}';
                          } else {
                            userData.ktaStatus = 'none';
                            userData.membershipNumber = '';
                            userData.membershipValidFrom = '';
                            userData.membershipValidUntil = '';
                          }
                          await userData.saveData();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _isMember
                                      ? 'Mode Member diaktifkan'
                                      : 'Mode Non-Member diaktifkan',
                                ),
                                backgroundColor: const Color(0xFF10B982),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        activeColor: const Color(0xFF10B982),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Toggle untuk beralih antara mode Member dan Non-Member',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFA16207),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // KTA Button (dynamic based on member status)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _isMember
                          ? const KtaCardScreen()
                          : const UploadKtaScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B982),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isMember ? Icons.card_membership : Icons.upload_file,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isMember ? 'Lihat KTA' : 'Pengajuan KTA',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Keluar Akun',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: enabled ? const Color(0xFF10B982) : const Color(0xFFE5E7EB),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: enabled ? const Color(0xFF10B982) : const Color(0xFFE5E7EB),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF10B982), width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (enabled && (value == null || value.isEmpty)) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF10B982),
      unselectedItemColor: const Color(0xFF9CA3AF),
      currentIndex: 4,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_score),
          label: 'Latihan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_membership),
          label: 'KTA',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      onTap: (index) {
        if (index == 4) {
          // Already on profile
          return;
        }
        
        Widget destination;
        
        switch (index) {
          case 0: // Dashboard
            destination = const DashboardNonMember();
            break;
          case 1: // Latihan - Mulai training baru
            destination = const SetupTrainingScreen();
            break;
          case 2: // KTA - Show card if member, upload if not
            destination = _isMember ? const KtaCardScreen() : const UploadKtaScreen();
            break;
          case 3: // Riwayat Latihan - Lihat history
            destination = const ArcherScoringScreen();
            break;
          default:
            return;
        }
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
