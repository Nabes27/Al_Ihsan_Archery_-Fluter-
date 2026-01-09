import 'package:flutter/material.dart';
import 'verification_status_screen.dart';
import 'profile_screen.dart';
import 'dashboard_non_member.dart';
import 'archer_scoring_screen.dart';
import 'setup_training_screen.dart';

class UploadKtaScreen extends StatefulWidget {
  const UploadKtaScreen({super.key});

  @override
  State<UploadKtaScreen> createState() => _UploadKtaScreenState();
}

class _UploadKtaScreenState extends State<UploadKtaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noAnggotaController = TextEditingController();
  String? _uploadedKtaImage;

  @override
  void dispose() {
    _noAnggotaController.dispose();
    super.dispose();
  }

  void _pickKtaImage() {
    // TODO: Implement image picker
    setState(() {
      _uploadedKtaImage = 'placeholder'; // Placeholder for now
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur upload gambar akan segera hadir!'),
        backgroundColor: Color(0xFF10B982),
      ),
    );
  }

  void _submitKta() {
    if (_formKey.currentState!.validate()) {
      if (_uploadedKtaImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan upload KTA terlebih dahulu!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Navigate to verification status screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VerificationStatusScreen()),
      );
    }
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
          'Upload KTA',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Upload KTA Section
                Container(
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
                      const Text(
                        'Upload KTA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Upload Area
                      GestureDetector(
                        onTap: _pickKtaImage,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF10B982),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFF0FDF4),
                          ),
                          child: _uploadedKtaImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 48,
                                      color: const Color(0xFF10B982),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Tap untuk upload KTA',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Format: JPG, PNG (Max 5MB)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                )
                              : Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.check_circle,
                                            size: 48,
                                            color: Color(0xFF10B982),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'KTA berhasil diupload',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF10B982),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _uploadedKtaImage = null;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // No Anggota
                      const Text(
                        'No Anggota',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _noAnggotaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Masukkan nomor anggota',
                          hintStyle: TextStyle(color: Colors.grey[400]),
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
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor anggota tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Upload KTA Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _submitKta,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B982),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Upload KTA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Bottom Navigation
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF10B982),
            unselectedItemColor: const Color(0xFF9CA3AF),
            currentIndex: 2,
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
              if (index == 2) {
                // Already on upload KTA
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
        ],
      ),
    );
  }
}
