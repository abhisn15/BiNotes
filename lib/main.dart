import 'dart:async';

import 'package:BiNotes/Catatan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:BiNotes/DatabaseHelper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: "BiNotes",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // Function to check login status
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    // Delay for 3 seconds for splash screen visibility
    await Future.delayed(Duration(seconds: 3));

    if (username != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(username)),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Username()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/icon_app.png',
          width: 255,
          height: 255,
        ),
      ),
    );
  }
}

class Username extends StatefulWidget {
  @override
  _UsernameState createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Siapa Namamu?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Masukkan Namamu',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text.trim();
                if (username.isNotEmpty) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('username', username);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(username)),
                  );
                }
              },
              child: Text('Save Username'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String username;
  final String waktuSaatIni;

  HomeScreen(this.username) : waktuSaatIni = waktuHariIni();

  static String waktuHariIni() {
    DateTime currentTime = DateTime.now().toLocal();
    int waktu = currentTime.hour;

    if (waktu >= 1 && waktu < 11) {
      return 'Pagi';
    } else if (waktu >= 11 && waktu < 15) {
      return 'Siang';
    } else if (waktu >= 15 && waktu < 18) {
      return 'Sore';
    } else {
      return 'Malam';
    }
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedMonth;
  String? selectedYear;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Brightness brightness = Brightness.light;
    Color appBarTextColor = Colors.black;

    if (widget.waktuSaatIni == 'Sore' || widget.waktuSaatIni == 'Malam') {
      brightness = Brightness.dark;
      appBarTextColor = Colors.white;
    }

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Selamat ${widget.waktuSaatIni}, ${widget.username}',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: appBarTextColor),
          ),
        ),
        backgroundColor:
            brightness == Brightness.light ? Colors.white : Colors.black,
      ),
      backgroundColor:
          brightness == Brightness.light ? Colors.white : Colors.black,
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          // DropdownButton<String>(
          //   value: selectedMonth,
          //   hint: Text(
          //     'Bulan',
          //     style: TextStyle(
          //         color: brightness == Brightness.light
          //             ? Colors.black
          //             : Colors.white),
          //   ),
          //   onChanged: (newValue) {
          //     setState(() {
          //       selectedMonth = newValue;
          //     });
          //   },
          //   dropdownColor: brightness == Brightness.light
          //       ? Colors.white
          //       : Colors.black,
          //   items: [
          //     DropdownMenuItem(
          //       value: '1',
          //       child: Text(
          //         'Januari',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '2',
          //       child: Text(
          //         'Februari',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '3',
          //       child: Text(
          //         'Maret',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '4',
          //       child: Text(
          //         'April',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '5',
          //       child: Text(
          //         'Mei',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '6',
          //       child: Text(
          //         'Juni',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '7',
          //       child: Text(
          //         'Juli',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '8',
          //       child: Text(
          //         'Agustus',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '9',
          //       child: Text(
          //         'September',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '10',
          //       child: Text(
          //         'Oktober',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '11',
          //       child: Text(
          //         'November',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //     DropdownMenuItem(
          //       value: '12',
          //       child: Text(
          //         'Desember',
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     ),
          //   ],
          // ),
          // DropdownButton<String>(
          //   value: selectedYear,
          //   hint: Text(
          //     'Tahun',
          //     style: TextStyle(
          //         color: brightness == Brightness.light
          //             ? Colors.black
          //             : Colors.white),
          //   ),
          //   onChanged: (newValue) {
          //     setState(() {
          //       selectedYear = newValue;
          //     });
          //   },
          //   items: List.generate(10, (index) {
          //     return DropdownMenuItem(
          //       value: (2024 + index).toString(),
          //       child: Text(
          //         (2024 + index).toString(),
          //         style: TextStyle(
          //             color: brightness == Brightness.light
          //                 ? Colors.black
          //                 : Colors.white),
          //       ),
          //     );
          //   }),
          //   dropdownColor: brightness == Brightness.light
          //       ? Colors.white
          //       : Colors.black,
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       selectedMonth = null;
          //       selectedYear = null;
          //     });
          //   },
          //   child: Text('Reset'),
          // ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (context, snapshot) {
                return FutureBuilder<List<Catatan>>(
                  future: DatabaseHelper.instance.getCatatanList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Catatan> catatanList = snapshot.data!;
                      catatanList.sort((a, b) {
                        // Mengurutkan berdasarkan waktu yang diubah terakhir, dengan yang terbaru di bagian atas
                        DateTime timeA =
                            DateFormat('dd MMMM yyyy HH:mm').parse(a.waktu);
                        DateTime timeB =
                            DateFormat('dd MMMM yyyy HH:mm').parse(b.waktu);
                        return timeB.compareTo(timeA);
                      });

                      // Filter catatan berdasarkan tanggal, bulan, dan tahun yang dipilih
                      if (selectedMonth != null && selectedYear != null) {
                        catatanList = catatanList.where((catatan) {
                          DateTime catatanDate =
                              DateFormat('dd MMMM yyyy HH:mm')
                                  .parse(catatan.waktu);
                          return catatanDate.month ==
                                  int.parse(selectedMonth!) &&
                              catatanDate.year == int.parse(selectedYear!);
                        }).toList();
                      }

                      return ListView.builder(
                        itemCount: catatanList.length,
                        itemBuilder: (context, index) {
                          Catatan catatan = catatanList[index];
                          return ListTile(
                            title: Text(
                              catatan.judul,
                              style: TextStyle(
                                color: brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              catatan.isi.length > 50
                                  ? '${catatan.isi.substring(0, 50)}...'
                                  : catatan.isi,
                              style: TextStyle(
                                color: brightness == Brightness.light
                                    ? Colors.black87
                                    : Colors.white70,
                              ),
                            ),
                            trailing: Text(
                              catatan.waktu,
                              style: TextStyle(
                                color: brightness == Brightness.light
                                    ? Colors.black54
                                    : Colors.white60,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditCatatanScreen(catatan),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahCatatanScreen()),
          );
        },
        backgroundColor: Colors.white,
        tooltip: 'Menambah Catatan',
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class TambahCatatanScreen extends StatefulWidget {
  @override
  _TambahCatatanScreenState createState() => _TambahCatatanScreenState();
}

class _TambahCatatanScreenState extends State<TambahCatatanScreen> {
  final String waktuSaatIni = waktuHariIni();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  int id = 0;

  // Menyimpan riwayat catatan
  List<Catatan> history = [];
  List<Catatan> redoHistory = [];

  int hitungJumlahKarakter() {
    return _judulController.text.length + _isiController.text.length;
  }

  @override
  void initState() {
    super.initState();
    _getLastId();
    _judulController.addListener(() {
      setState(() {});
    });
    _isiController.addListener(() {
      setState(() {});
    });
    _judulController.addListener(_updateHistory);
    _isiController.addListener(_updateHistory);
    Timer.periodic(Duration(milliseconds: 100), (_) => setState(() {}));
  }

  static String waktuHariIni() {
    DateTime currentTime = DateTime.now().toLocal();
    int waktu = currentTime.hour;

    if (waktu >= 1 && waktu < 11) {
      return 'Pagi';
    } else if (waktu >= 11 && waktu < 15) {
      return 'Siang';
    } else if (waktu >= 15 && waktu < 18) {
      return 'Sore';
    } else {
      return 'Malam';
    }
  }

  // Fungsi untuk mendapatkan id terakhir dari database
  Future<void> _getLastId() async {
    int lastId = await DatabaseHelper.instance.getLastCatatanId();
    setState(() {
      id = lastId + 1;
    });
  }

  // Fungsi untuk menambah catatan ke history
  void addToHistory(Catatan catatan) {
    history.add(catatan);
  }

  void _updateHistory() {
    // Buat objek Catatan baru dan tambahkan ke dalam history
    Catatan newCatatan = Catatan(
      id: history.length + 1, // Gunakan panjang history + 1 sebagai id baru
      judul: _judulController.text,
      isi: _isiController.text,
      waktu: DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now()),
    );
    history.add(newCatatan);
  }

  // Fungsi untuk menghapus catatan terakhir dari history dan mengembalikan teks pada TextField
  void undo() {
    if (history.isNotEmpty) {
      setState(() {
        _judulController.text = history.last.judul;
        _isiController.text = history.last.isi;
        history.removeLast();
      });
    }
  }

// Fungsi untuk mengembalikan catatan yang telah dihapus sebelumnya
  void redo() {
    if (redoHistory.isNotEmpty) {
      setState(() {
        Catatan lastRedo = redoHistory.last;
        _judulController.text = lastRedo.judul;
        _isiController.text = lastRedo.isi;
        history.add(redoHistory
            .removeLast()); // Pindahkan kembali ke history saat melakukan redo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool canUndo = history.isNotEmpty; // Periksa apakah undo dapat dilakukan
    bool canRedo =
        redoHistory.isNotEmpty; // Periksa apakah redo dapat dilakukan
    ThemeData theme = Theme.of(context);
    Brightness brightness = Brightness.light;
    Color appBarTextColor = Colors.black;

    if (waktuSaatIni == 'Sore' || waktuSaatIni == 'Malam') {
      brightness = Brightness.dark;
      appBarTextColor = Colors.white;
    }

    Color floatingButtonColor = Colors.white;
    Color floatingButtonIconColor = Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: undo, // Panggil fungsi undo saat tombol undo ditekan
              icon: Icon(
                Icons.undo,
                color: canUndo
                    ? (brightness == Brightness.light
                        ? Colors.black
                        : Colors.white)
                    : Colors
                        .grey, // Warna ikon akan redup (abu-abu) jika undo tidak bisa dilakukan
              ),
            ),
            IconButton(
              onPressed: redo, // Panggil fungsi redo saat tombol redo ditekan
              icon: Icon(
                Icons.redo,
                color: canRedo
                    ? (brightness == Brightness.light
                        ? Colors.black
                        : Colors.white)
                    : Colors
                        .grey, // Warna ikon akan redup (abu-abu) jika redo tidak bisa dilakukan
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color:
                  brightness == Brightness.light ? Colors.black : Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor:
            brightness == Brightness.light ? Colors.white : Colors.black,
      ),
      backgroundColor:
          brightness == Brightness.light ? Colors.white : Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _judulController,
                maxLines: null,
                style: TextStyle(
                    color: brightness == Brightness.light
                        ? Color.fromARGB(255, 0, 0, 0)
                        : Colors.white,
                    fontSize: 20),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Judul Catatan',
                  hintStyle: TextStyle(
                      color: brightness == Brightness.light
                          ? Color.fromARGB(255, 118, 118, 118)
                          : Colors.white54),
                ),
              ),
              Text(
                'Dibuat pada ' +
                    DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now()) +
                    '  |  ' +
                    hitungJumlahKarakter().toString() +
                    ' Karakter',
                style: TextStyle(
                    color: brightness == Brightness.light
                        ? Colors.black45
                        : Colors.white54,
                    fontSize: 12),
              ),
              SizedBox(
                width: 10,
                height: 30,
              ),
              TextField(
                controller: _isiController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                    color: brightness == Brightness.light
                        ? Color.fromARGB(255, 23, 23, 23)
                        : Colors.white,
                    fontSize: 16.0),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Isi Catatan',
                  hintStyle: TextStyle(
                    color: brightness == Brightness.light
                        ? Color.fromARGB(255, 131, 131, 131)
                        : Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String judul = _judulController.text.trim();
          String isi = _isiController.text.trim();
          String waktu =
              DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now());

          if (judul.isNotEmpty && isi.isNotEmpty) {
            id++;
            // Ganti `id` dengan nilai yang sesuai
            Catatan catatan = Catatan(
              id: id, // Gunakan panjang history + 1 sebagai id baru
              judul: judul,
              isi: isi,
              waktu: waktu,
            );
            await DatabaseHelper.instance.insertCatatan(catatan);
            Navigator.pop(context);
          } else if (judul.isEmpty && isi.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mohon Masukkan Judul Catatan'),
              ),
            );
          } else if (judul.isNotEmpty && isi.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mohon Masukkan Isi Catatan'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Diisi Dulu Judul sama Catatannya Kocakk!!'),
              ),
            );
          }
        },
        backgroundColor: floatingButtonColor,
        tooltip: 'Tambah Catatan',
        child: Icon(Icons.save, color: floatingButtonIconColor),
      ),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }
}

class EditCatatanScreen extends StatefulWidget {
  final Catatan catatan; // Definisikan field catatan
  EditCatatanScreen(this.catatan);

  @override
  _EditCatatanScreenState createState() => _EditCatatanScreenState();
}

class _EditCatatanScreenState extends State<EditCatatanScreen> {
  final String waktuSaatIni = waktuHariIni();
  late TextEditingController _judulController;
  late TextEditingController _timeController;
  late TextEditingController _isiController;

  int hitungJumlahKarakter() {
    return _judulController.text.length + _isiController.text.length;
  }

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.catatan.judul);
    _timeController = TextEditingController(text: widget.catatan.waktu);
    _isiController = TextEditingController(text: widget.catatan.isi);
    _judulController.addListener(() {
      setState(() {});
    });
    _isiController.addListener(() {
      setState(() {});
    });
    Timer.periodic(Duration(milliseconds: 100), (_) => setState(() {}));
  }

  static String waktuHariIni() {
    DateTime currentTime = DateTime.now().toLocal();
    int waktu = currentTime.hour;

    if (waktu >= 1 && waktu < 11) {
      return 'Pagi';
    } else if (waktu >= 11 && waktu < 15) {
      return 'Siang';
    } else if (waktu >= 15 && waktu < 18) {
      return 'Sore';
    } else {
      return 'Malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Brightness brightness = Brightness.light;
    Color appBarTextColor = Colors.black;

    if (waktuSaatIni == 'Sore' || waktuSaatIni == 'Malam') {
      brightness = Brightness.dark;
      appBarTextColor = Colors.white;
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Share.share(
                    widget.catatan.judul + '\n' + '\n' + widget.catatan.isi);
              },
              icon: Icon(
                Icons.ios_share_outlined,
                color: brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                // Fungsi yang akan dijalankan ketika tombol ditekan
              },
              icon: Icon(
                Icons.more_vert,
                color: brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            )
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color:
                  brightness == Brightness.light ? Colors.black : Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor:
            brightness == Brightness.light ? Colors.white : Colors.black,
      ),
      backgroundColor:
          brightness == Brightness.light ? Colors.white : Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _judulController,
                maxLines: null,
                style: TextStyle(
                    color: brightness == Brightness.light
                        ? Color.fromARGB(255, 0, 0, 0)
                        : Colors.white,
                    fontSize: 20),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Judul Catatan',
                  hintStyle: TextStyle(
                      color: brightness == Brightness.light
                          ? Color.fromARGB(255, 0, 0, 0)
                          : Colors.white54),
                ),
              ),
              Text(
                'Dibuat pada ' +
                    widget.catatan.waktu +
                    '  |  ' +
                    hitungJumlahKarakter().toString() +
                    ' Karakter',
                style: TextStyle(
                    color: brightness == Brightness.light
                        ? Colors.black54
                        : Colors.white54,
                    fontSize: 12),
              ),
              SizedBox(
                width: 10,
                height: 30,
              ),
              TextField(
                controller: _isiController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                    color: brightness == Brightness.light
                        ? Color.fromARGB(255, 33, 33, 33)
                        : Colors.white,
                    fontSize: 16.0),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Isi Catatan',
                  hintStyle: TextStyle(
                    color: brightness == Brightness.light
                        ? Color.fromARGB(255, 33, 33, 33)
                        : Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              String judul = _judulController.text.trim();
              String isi = _isiController.text.trim();

              if (judul.isEmpty || isi.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Judul dan isi catatan harus diisi'),
                  ),
                );
              } else {
                Catatan catatan = Catatan(
                  id: widget.catatan.id,
                  judul: judul,
                  isi: isi,
                  waktu: widget.catatan.waktu,
                );

                DatabaseHelper.instance.updateCatatan(catatan).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Perubahan catatan berhasil disimpan'),
                    ),
                  );
                  Navigator.pop(context);
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menyimpan perubahan catatan'),
                    ),
                  );
                });
              }
            },
            backgroundColor:
                brightness == Brightness.light ? Colors.white : Colors.white,
            hoverColor: Colors.white60,
            tooltip: 'Merubah Catatan',
            child: Icon(
              Icons.save,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10), // Spacer antara tombol Simpan dan Hapus
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Hapus Catatan'),
                    content:
                        Text('Apakah Anda yakin ingin menghapus catatan ini?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                        },
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await DatabaseHelper.instance
                              .deleteCatatan(widget.catatan.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Catatan berhasil dihapus'),
                            ),
                          );
                          Navigator.of(context).pop(); // Tutup dialog
                          Navigator.of(context)
                              .pop(); // Kembali ke halaman sebelumnya
                        },
                        child: Text('Yakin'),
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor:
                brightness == Brightness.light ? Colors.white : Colors.white,
            tooltip: 'Hapus Catatan',
            child: Icon(
              Icons.delete,
              color: Colors.red[400],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }
}
