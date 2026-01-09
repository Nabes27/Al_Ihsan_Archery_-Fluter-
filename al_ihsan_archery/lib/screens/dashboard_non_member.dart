import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'upload_kta_screen.dart';
import 'archer_scoring_screen.dart';
import 'setup_training_screen.dart';
import 'kta_card_screen.dart';
import 'Mamber/pembayaran_screen.dart';
import '../utils/user_data.dart';

class DashboardNonMember extends StatefulWidget {
  const DashboardNonMember({super.key});

  @override
  State<DashboardNonMember> createState() => _DashboardNonMemberState();
}

class _DashboardNonMemberState extends State<DashboardNonMember> {
  bool _isLoading = true;
  bool _isMember = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await UserData().loadData();
    setState(() {
      _isMember = UserData().isMember;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF10B982),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF10B982),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selamat Datang,',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Halo, Pemanah!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {
                          // TODO: Implement notifications
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Hero Card with Recommendation Badge (only show if not member)
                if (!_isMember)
                  Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage('image/logo_Alihsan Archery.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 80),
                            const Text(
                              'Bergabunglah Menjadi Anggota Resmi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Dapatkan fasilitas premium dan bimbingan pelatih profesional.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UploadKtaScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B982),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Ajukan KTA Sekarang',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B982),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Rekomendasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!_isMember) const SizedBox(height: 24),
                // Menu Utama
                const Text(
                  'Menu Utama',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Grid Menu
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.sports_score,
                      title: 'Latihan',
                      subtitle: 'Akses penuh scoring',
                      color: const Color(0xFF10B982),
                      iconColor: Colors.white,
                      isLocked: false,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.assessment_outlined,
                      title: 'Profil Dasar',
                      subtitle: 'Kelola data diri & foto',
                      color: const Color(0xFF6366F1),
                      iconColor: Colors.white,
                      isLocked: false,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.card_membership_outlined,
                      title: _isMember ? 'KTA' : 'Pengajuan KTA',
                      subtitle: _isMember ? 'Kartu anggota' : 'Daftar anggota resmi',
                      color: const Color(0xFFF59E0B),
                      iconColor: Colors.white,
                      isLocked: false,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.history,
                      title: 'Riwayat Latihan',
                      subtitle: 'Pantau progress latihan',
                      color: const Color(0xFF3B82F6),
                      iconColor: Colors.white,
                      isLocked: false,
                    ),
                    // Member-only features (locked for non-members)
                    _buildMenuItem(
                      context,
                      icon: Icons.notifications_outlined,
                      title: 'Notifikasi',
                      subtitle: 'Event & pengumuman',
                      color: const Color(0xFFEC4899),
                      iconColor: Colors.white,
                      isLocked: !_isMember,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.emoji_events_outlined,
                      title: 'Lomba',
                      subtitle: 'Pendaftaran lomba',
                      color: const Color(0xFF8B5CF6),
                      iconColor: Colors.white,
                      isLocked: !_isMember,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.payment_outlined,
                      title: 'Pembayaran',
                      subtitle: 'Iuran & transaksi',
                      color: const Color(0xFF14B8A6),
                      iconColor: Colors.white,
                      isLocked: !_isMember,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.how_to_reg_outlined,
                      title: 'Absensi',
                      subtitle: 'Presensi latihan',
                      color: const Color(0xFFF97316),
                      iconColor: Colors.white,
                      isLocked: !_isMember,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF10B982),
        unselectedItemColor: const Color(0xFF9CA3AF),
        currentIndex: 0,
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
          if (index == 0) {
            // Already on dashboard
            return;
          }
          
          Widget destination;
          
          switch (index) {
            case 1: // Latihan - Mulai training baru
              destination = const SetupTrainingScreen();
              break;
            case 2: // KTA - Show card if member, upload if not
              destination = _isMember ? const KtaCardScreen() : const UploadKtaScreen();
              break;
            case 3: // Riwayat Latihan - Lihat history
              destination = const ArcherScoringScreen();
              break;
            case 4: // Profil
              destination = const ProfileScreen();
              break;
            default:
              return;
          }
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required bool isLocked,
  }) {
    return GestureDetector(
      onTap: () {
        if (isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur ini hanya tersedia untuk anggota. Silakan ajukan KTA terlebih dahulu.'),
              backgroundColor: Color(0xFFF59E0B),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        if (title == 'Latihan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SetupTrainingScreen()),
          );
        } else if (title == 'Profil Dasar') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (title == 'KTA') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KtaCardScreen()),
          );
        } else if (title == 'Pengajuan KTA') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadKtaScreen()),
          );
        } else if (title == 'Riwayat Latihan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ArcherScoringScreen()),
          );
        } else if (title == 'Pembayaran') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PembayaranScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur ini akan segera hadir!'),
              backgroundColor: Color(0xFF10B982),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isLocked ? const Color(0xFF9CA3AF) : color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isLocked ? const Color(0xFF9CA3AF) : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: isLocked ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lock overlay
          if (isLocked)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.lock,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
