import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const AgeCalculatorPage(),
    );
  }
}

class AgeCalculatorPage extends StatefulWidget {
  const AgeCalculatorPage({super.key});

  @override
  State<AgeCalculatorPage> createState() => _AgeCalculatorPageState();
}

class _AgeCalculatorPageState extends State<AgeCalculatorPage> {
  // State Variables
  DateTime? birthDate;
  String result = '';

  final TextEditingController _dateInputController = TextEditingController();

  /// Memformat tanggal menjadi string yang mudah dibaca
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  DateTime? _parseDate(String value) {
    try {
      final parts = value.split('/');
      if (parts.length != 3) return null;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  // Functions

  // Date picker untuk memilih tanggal lahir
  // Future<void> pickDate() async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: birthDate ?? DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //     helpText: 'Pilih Tanggal Lahir',
  //     cancelText: 'Batal',
  //     confirmText: 'Pilih',
  //   );

  //   if (picked != null) {
  //     setState(() {
  //       birthDate = picked;
  //       result = ''; // Reset hasil saat tanggal berubah
  //     });
  //   }
  // }

  void _formatDateInput(String value) {
    String digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    String formatted = '';

    if (digits.length >= 2) {
      formatted = digits.substring(0, 2);
    } else {
      formatted = digits;
    }

    if (digits.length >= 4) {
      formatted += '/${digits.substring(2, 4)}';
    } else if (digits.length > 2) {
      formatted += '/${digits.substring(2)}';
    }

    if (digits.length >= 8) {
      formatted += '/${digits.substring(4, 8)}';
    } else if (digits.length > 4) {
      formatted += '/${digits.substring(4)}';
    }

    _dateInputController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _openCustomDatePicker() async {
    _dateInputController.clear();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Masukkan Tanggal Lahir'),
          content: TextField(
            controller: _dateInputController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: const InputDecoration(
              hintText: 'DD/MM/YYYY',
              counterText: '',
              border: OutlineInputBorder(),
            ),
            onChanged: _formatDateInput,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final parsedDate = _parseDate(_dateInputController.text);

                if (parsedDate != null) {
                  setState(() {
                    birthDate = parsedDate;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Hitung umur berdasarkan tanggal lahir
  void calculateAge() {
    if (birthDate == null) return;

    final DateTime today = DateTime.now();
    int years = today.year - birthDate!.year;
    int months = today.month - birthDate!.month;
    int days = today.day - birthDate!.day;

    // Jika hari negatif, kurangi 1 bulan dan tambahkan hari bulan sebelumnya
    if (days < 0) {
      months--;
      final DateTime lastMonth = DateTime(today.year, today.month, 0);
      days += lastMonth.day;
    }

    // Jika bulan negatif, kurangi 1 tahun dan tambahkan 12 bulan
    if (months < 0) {
      years--;
      months += 12;
    }

    setState(() {
      result = "$years tahun, $months bulan, $days hari";
    });
  }

  // UI Widgets

  /// Header dengan icon dan judul
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade100, Colors.purple.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cake_rounded,
              size: 48,
              color: Colors.indigo.shade600,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Age Calculator',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hitung umur Anda dengan akurat',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Card untuk menampilkan tanggal lahir yang dipilih
  Widget _buildBirthDateCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.indigo.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tanggal Lahir',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              birthDate == null
                  ? 'Belum memilih tanggal lahir'
                  : formatDate(birthDate!),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:
                    birthDate == null ? Colors.grey.shade400 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card untuk menampilkan hasil perhitungan umur
  Widget _buildResultCard() {
    if (result.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.purple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.celebration_rounded,
                size: 48,
                color: Colors.indigo.shade600,
              ),
              const SizedBox(height: 16),
              const Text(
                'Umur Anda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tombol untuk memilih tanggal lahir
  Widget _buildPickDateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _openCustomDatePicker,
        icon: const Icon(Icons.date_range_rounded, size: 24),
        label: const Text(
          'Pilih Tanggal Lahir',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade600,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Tombol untuk menghitung umur
  Widget _buildCalculateButton() {
    final bool isEnabled = birthDate != null;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isEnabled ? calculateAge : null,
        icon: const Icon(Icons.calculate_rounded, size: 24),
        label: const Text(
          'Hitung Umur',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple.shade600,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Age Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildBirthDateCard(),
            const SizedBox(height: 24),
            _buildPickDateButton(),
            const SizedBox(height: 16),
            _buildCalculateButton(),
            const SizedBox(height: 24),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }
}
