import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════

class Hotel {
  final int id;
  final String nama;
  final String kota;
  final int hargaPerMalam;
  final String deskripsi;
  final List<String> fasilitas;
  final String gambar;

  const Hotel({
    required this.id,
    required this.nama,
    required this.kota,
    required this.hargaPerMalam,
    required this.deskripsi,
    required this.fasilitas,
    required this.gambar,
  });
}

String formatRupiah(num angka) {
  final str = angka.toInt().toString();
  String hasil = '';
  int hitung = 0;
  for (int i = str.length - 1; i >= 0; i--) {
    hitung++;
    hasil = str[i] + hasil;
    if (hitung % 3 == 0 && i > 0) {
      hasil = '.$hasil';
    }
  }
  return 'Rp $hasil';
}

class Booking {
  final String kode;
  final Hotel hotel;
  final String namaTamu;
  final int jumlahMalam;
  final String tipeKamar;
  final double total;
  final DateTime tanggalPesan;
  String status;

  Booking({
    required this.kode,
    required this.hotel,
    required this.namaTamu,
    required this.jumlahMalam,
    required this.tipeKamar,
    required this.total,
    required this.tanggalPesan,
    required this.status,
  });
}

String formatTanggal(DateTime tanggal) {
  const bulan = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  return '${tanggal.day} ${bulan[tanggal.month - 1]} ${tanggal.year}';
}

// ════════════════════════════════════════════════
// SERVICE
// ════════════════════════════════════════════════

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  int _penghitung = 0;
  final List<Booking> _daftarBooking = [];

  final List<Hotel> _daftarHotel = const [
    Hotel(
      id: 1,
      nama: 'Malioboro Grand Hotel',
      kota: 'Yogyakarta',
      hargaPerMalam: 750000,
      deskripsi:
          'Hotel mewah di pusat kota Yogyakarta, hanya beberapa langkah '
          'dari Jalan Malioboro. Nikmati kenyamanan kamar modern dengan '
          'pemandangan kota yang menakjubkan.',
      fasilitas: ['Wi-Fi', 'Sarapan', 'Kolam Renang'],
      gambar: 'assets/images/malioboro.png',
    ),
    Hotel(
      id: 2,
      nama: 'Prambanan View Resort',
      kota: 'Yogyakarta',
      hargaPerMalam: 1500000,
      deskripsi:
          'Resort eksklusif dengan pemandangan langsung ke Candi Prambanan '
          'yang megah. Tempat sempurna untuk bersantai sambil menikmati '
          'keindahan warisan budaya Indonesia.',
      fasilitas: ['Wi-Fi', 'Spa', 'Restoran'],
      gambar: 'assets/images/prambanan.png',
    ),
    Hotel(
      id: 3,
      nama: 'Bali Sunset Bay',
      kota: 'Bali',
      hargaPerMalam: 2100000,
      deskripsi:
          'Resort tepi pantai di Bali dengan pemandangan matahari terbenam '
          'yang memukau. Rasakan suasana tropis yang menenangkan dengan '
          'akses langsung ke pantai pasir putih.',
      fasilitas: ['Wi-Fi', 'Pantai', 'Bar'],
      gambar: 'assets/images/bali.png',
    ),
  ];

  Future<List<Hotel>> ambilHotel() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _daftarHotel;
  }

  Future<Booking> buatBooking(
    Hotel hotel,
    String nama,
    int malam,
    String tipeKamar,
    double total,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    _penghitung++;
    final kode = 'SE-${_penghitung.toString().padLeft(4, '0')}';
    final booking = Booking(
      kode: kode,
      hotel: hotel,
      namaTamu: nama,
      jumlahMalam: malam,
      tipeKamar: tipeKamar,
      total: total,
      tanggalPesan: DateTime.now(),
      status: 'Dikonfirmasi',
    );
    _daftarBooking.add(booking);
    return booking;
  }

  Future<List<Booking>> ambilRiwayat() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _daftarBooking.reversed.toList();
  }

  Future<void> batalkanBooking(String kode) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final booking = _daftarBooking.firstWhere((b) => b.kode == kode);
    booking.status = 'Dibatalkan';
  }
}

// ════════════════════════════════════════════════
// HELPER WIDGET
// ════════════════════════════════════════════════

void tampilkanNotif(BuildContext context, String pesan, {bool sukses = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            sukses ? Icons.check_circle : Icons.error,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              pesan,
              style: GoogleFonts.lato(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: sukses ? Colors.green.shade800 : Colors.red.shade800,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}

// ════════════════════════════════════════════════
// ENTRY POINT
// ════════════════════════════════════════════════

void main() {
  runApp(const StayEaseApp());
}

class StayEaseApp extends StatelessWidget {
  const StayEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StayEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}

// ════════════════════════════════════════════════
// HOME PAGE (shell navigasi)
// ════════════════════════════════════════════════

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabAktif = 0;
  List<Hotel> _hotels = [];
  final Set<int> _favorit = {};

  @override
  void initState() {
    super.initState();
    _muatHotel();
  }

  Future<void> _muatHotel() async {
    final hotels = await BookingService().ambilHotel();
    if (!mounted) return;
    setState(() => _hotels = hotels);
  }

  void _toggleFavorit(int id) {
    setState(() {
      if (_favorit.contains(id)) {
        _favorit.remove(id);
      } else {
        _favorit.add(id);
      }
    });
  }

  static const _labelTab = ['Beranda', 'Favorit', 'Pesanan', 'Profil'];
  static const _ikonTab = [
    Icons.home_outlined,
    Icons.favorite_outline,
    Icons.receipt_long_outlined,
    Icons.person_outline,
  ];
  static const _ikonAktif = [
    Icons.home,
    Icons.favorite,
    Icons.receipt_long,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final halaman = [
      DaftarHotelPage(
        hotels: _hotels,
        favorit: _favorit,
        onToggleFavorit: _toggleFavorit,
      ),
      FavoritPage(
        hotels: _hotels,
        favorit: _favorit,
        onToggleFavorit: _toggleFavorit,
      ),
      const PesananPage(),
      const ProfilPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _tabAktif,
        children: halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabAktif,
        onDestinationSelected: (i) => setState(() => _tabAktif = i),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: List.generate(
          _labelTab.length,
          (i) => NavigationDestination(
            icon: Icon(_ikonTab[i]),
            selectedIcon: Icon(_ikonAktif[i], color: theme.colorScheme.primary),
            label: _labelTab[i],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════
// DAFTAR HOTEL PAGE
// ════════════════════════════════════════════════

class DaftarHotelPage extends StatelessWidget {
  final List<Hotel> hotels;
  final Set<int> favorit;
  final void Function(int id) onToggleFavorit;

  const DaftarHotelPage({
    super.key,
    required this.hotels,
    required this.favorit,
    required this.onToggleFavorit,
  });

  void _bukaDetail(BuildContext context, Hotel hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailHotelPage(hotel: hotel)),
    );
  }

  void _toggleFavorit(BuildContext context, int id) {
    final ditambah = !favorit.contains(id);
    onToggleFavorit(id);
    tampilkanNotif(
      context,
      ditambah ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'StayEase',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: hotels.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return _KartuHotel(
                  hotel: hotel,
                  isFavorit: favorit.contains(hotel.id),
                  onTap: () => _bukaDetail(context, hotel),
                  onFavoritTap: () => _toggleFavorit(context, hotel.id),
                );
              },
            ),
    );
  }
}

class _KartuHotel extends StatelessWidget {
  final Hotel hotel;
  final bool isFavorit;
  final VoidCallback onTap;
  final VoidCallback onFavoritTap;

  const _KartuHotel({
    required this.hotel,
    required this.isFavorit,
    required this.onTap,
    required this.onFavoritTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'hotel-${hotel.id}',
              child: Image.asset(
                hotel.gambar,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.lightBlue.shade100,
                  child: const Center(
                    child: Icon(Icons.hotel, size: 48, color: Colors.lightBlue),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel.nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hotel.kota,
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formatRupiah(hotel.hargaPerMalam)} / malam',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorit ? Icons.favorite : Icons.favorite_border,
                      color: isFavorit ? Colors.red : Colors.grey,
                    ),
                    onPressed: onFavoritTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════
// DETAIL HOTEL PAGE
// ════════════════════════════════════════════════

class DetailHotelPage extends StatelessWidget {
  final Hotel hotel;
  const DetailHotelPage({super.key, required this.hotel});

  void _pesanSekarang(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FormBookingPage(hotel: hotel),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Hotel',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'hotel-${hotel.id}',
              child: Image.asset(
                hotel.gambar,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.lightBlue.shade100,
                  child: const Center(
                    child: Icon(
                      Icons.hotel,
                      size: 64,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hotel.kota,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${formatRupiah(hotel.hargaPerMalam)} / malam',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(hotel.deskripsi, style: GoogleFonts.lato(fontSize: 14)),
                  const SizedBox(height: 16),
                  Text(
                    'Fasilitas',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: hotel.fasilitas
                        .map(
                          (f) => Chip(
                            label: Text(f, style: GoogleFonts.lato(fontSize: 12)),
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _pesanSekarang(context),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Pesan Sekarang',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════
// FAVORIT PAGE
// ════════════════════════════════════════════════

class FavoritPage extends StatelessWidget {
  final Set<int> favorit;
  final List<Hotel> hotels;
  final void Function(int id) onToggleFavorit;

  const FavoritPage({
    super.key,
    required this.favorit,
    required this.hotels,
    required this.onToggleFavorit,
  });

  @override
  Widget build(BuildContext context) {
    final hotelFavorit = hotels.where((h) => favorit.contains(h.id)).toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorit',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: hotelFavorit.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada hotel favorit',
                    style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ketuk ikon ♡ pada hotel untuk menyimpannya',
                    style: GoogleFonts.lato(fontSize: 13, color: Colors.grey.shade400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hotelFavorit.length,
              itemBuilder: (context, index) {
                final hotel = hotelFavorit[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        hotel.gambar,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, _) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.lightBlue.shade100,
                          child: const Icon(Icons.hotel, color: Colors.lightBlue),
                        ),
                      ),
                    ),
                    title: Text(
                      hotel.nama,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
                            const SizedBox(width: 2),
                            Text(
                              hotel.kota,
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${formatRupiah(hotel.hargaPerMalam)} / malam',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailHotelPage(hotel: hotel),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ════════════════════════════════════════════════
// FORM BOOKING PAGE
// ════════════════════════════════════════════════

class FormBookingPage extends StatefulWidget {
  final Hotel hotel;
  const FormBookingPage({super.key, required this.hotel});

  @override
  State<FormBookingPage> createState() => _FormBookingPageState();
}

class _FormBookingPageState extends State<FormBookingPage> {
  final _namaTamuController = TextEditingController();
  int _jumlahMalam = 1;
  String _tipeKamar = 'Standard';
  bool _memuat = false;

  @override
  void dispose() {
    _namaTamuController.dispose();
    super.dispose();
  }

  void _ubahMalam(int perubahan) {
    setState(() {
      _jumlahMalam = (_jumlahMalam + perubahan).clamp(1, 7);
    });
  }

  void _pilihKamar(String tipe) {
    setState(() {
      _tipeKamar = tipe;
    });
  }

  double _hitungTotal() {
    final pengali = _tipeKamar == 'Deluxe' ? 1.5 : 1.0;
    return widget.hotel.hargaPerMalam * _jumlahMalam * pengali;
  }

  Future<void> _konfirmasi() async {
    if (_namaTamuController.text.trim().isEmpty) {
      tampilkanNotif(context, 'Nama tamu wajib diisi', sukses: false);
      return;
    }

    setState(() => _memuat = true);

    final booking = await BookingService().buatBooking(
      widget.hotel,
      _namaTamuController.text.trim(),
      _jumlahMalam,
      _tipeKamar,
      _hitungTotal(),
    );

    if (!mounted) return;
    setState(() => _memuat = false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            Text(
              'Booking Berhasil',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _BarisRingkasan(label: 'Kode', nilai: booking.kode),
            _BarisRingkasan(label: 'Hotel', nilai: booking.hotel.nama),
            _BarisRingkasan(label: 'Tamu', nilai: booking.namaTamu),
            _BarisRingkasan(
              label: 'Durasi',
              nilai: '${booking.jumlahMalam} malam',
            ),
            _BarisRingkasan(label: 'Kamar', nilai: booking.tipeKamar),
            _BarisRingkasan(
              label: 'Total',
              nilai: formatRupiah(booking.total),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK', style: GoogleFonts.poppins(fontSize: 14)),
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    Navigator.popUntil(context, (route) => route.isFirst);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Pesanan ${booking.kode} berhasil disimpan',
                style: GoogleFonts.lato(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = _hitungTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Form Booking',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.hotel.nama,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${formatRupiah(widget.hotel.hargaPerMalam)} / malam',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text('Nama Tamu', style: GoogleFonts.lato(fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _namaTamuController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama lengkap',
                hintStyle: GoogleFonts.lato(fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: GoogleFonts.lato(fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text('Jumlah Malam', style: GoogleFonts.lato(fontSize: 14)),
                const Spacer(),
                IconButton(
                  onPressed: () => _ubahMalam(-1),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$_jumlahMalam',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => _ubahMalam(1),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Tipe Kamar', style: GoogleFonts.lato(fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _PilihanKamar(
                    tipe: 'Standard',
                    keterangan: 'x1',
                    terpilih: _tipeKamar == 'Standard',
                    onTap: () => _pilihKamar('Standard'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PilihanKamar(
                    tipe: 'Deluxe',
                    keterangan: 'x1.5',
                    terpilih: _tipeKamar == 'Deluxe',
                    onTap: () => _pilihKamar('Deluxe'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3 + (_jumlahMalam / 7) * 0.7,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Total Biaya',
                    style: GoogleFonts.lato(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatRupiah(total),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _memuat ? null : _konfirmasi,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _memuat
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Konfirmasi',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PilihanKamar extends StatelessWidget {
  final String tipe;
  final String keterangan;
  final bool terpilih;
  final VoidCallback onTap;

  const _PilihanKamar({
    required this.tipe,
    required this.keterangan,
    required this.terpilih,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: terpilih
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                terpilih ? theme.colorScheme.primary : Colors.grey.shade300,
            width: terpilih ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              tipe,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: terpilih ? FontWeight.w600 : FontWeight.normal,
                color: terpilih
                    ? theme.colorScheme.primary
                    : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              keterangan,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarisRingkasan extends StatelessWidget {
  final String label;
  final String nilai;

  const _BarisRingkasan({required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: GoogleFonts.lato(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              nilai,
              style: GoogleFonts.lato(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// PESANAN PAGE
// ════════════════════════════════════════════════

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  List<Booking> _riwayat = [];
  bool _memuat = true;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    final data = await BookingService().ambilRiwayat();
    if (!mounted) return;
    setState(() {
      _riwayat = data;
      _memuat = false;
    });
  }

  Future<void> _batalkan(String kode) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Batalkan pesanan ini?',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Tidak', style: GoogleFonts.poppins(fontSize: 14)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Ya, batalkan',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;

    await BookingService().batalkanBooking(kode);
    if (!mounted) return;

    tampilkanNotif(context, 'Pesanan $kode dibatalkan');
    _muat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesanan Saya',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: _memuat
          ? const Center(child: CircularProgressIndicator())
          : _riwayat.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada pesanan',
                        style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pesan hotel dari halaman Beranda',
                        style: GoogleFonts.lato(fontSize: 13, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _muat,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _riwayat.length,
                    itemBuilder: (context, index) {
                      final booking = _riwayat[index];
                      final aktif = booking.status == 'Dikonfirmasi';
                      final warnaStatus =
                          aktif ? Colors.green.shade700 : Colors.red.shade700;

                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    booking.kode,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: warnaStatus.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      booking.status,
                                      style: GoogleFonts.lato(
                                          fontSize: 12, color: warnaStatus),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              Text(
                                booking.hotel.nama,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _InfoBaris(
                                icon: Icons.person_outline,
                                text: booking.namaTamu,
                              ),
                              _InfoBaris(
                                icon: Icons.bed_outlined,
                                text: '${booking.tipeKamar} · ${booking.jumlahMalam} malam',
                              ),
                              _InfoBaris(
                                icon: Icons.calendar_today_outlined,
                                text: formatTanggal(booking.tanggalPesan),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatRupiah(booking.total),
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (aktif)
                                    OutlinedButton(
                                      onPressed: () => _batalkan(booking.kode),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red.shade700,
                                        side: BorderSide(color: Colors.red.shade300),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        'Batalkan',
                                        style: GoogleFonts.poppins(fontSize: 12),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class _InfoBaris extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoBaris({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          Text(text, style: GoogleFonts.lato(fontSize: 13, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// PROFIL PAGE
// ════════════════════════════════════════════════

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      'U',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'User StayEase',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'user@stayease.id',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _MenuProfil(
              icon: Icons.person_outline,
              label: 'Edit Profil',
              onTap: () {},
            ),
            _MenuProfil(
              icon: Icons.notifications_outlined,
              label: 'Notifikasi',
              onTap: () {},
            ),
            _MenuProfil(
              icon: Icons.lock_outline,
              label: 'Keamanan',
              onTap: () {},
            ),
            _MenuProfil(
              icon: Icons.help_outline,
              label: 'Bantuan',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            Text(
              'StayEase v1.0.0',
              style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MenuProfil extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuProfil({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(label, style: GoogleFonts.lato(fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
