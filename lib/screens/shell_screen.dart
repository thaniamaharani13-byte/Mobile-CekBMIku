import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Kerangka halaman sesudah login.
/// Navbar adalah milik Scaffold (bukan bagian ListView), sehingga TETAP
/// terlihat ketika konten halaman digulir dan mengikuti lebar perangkat.
class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  static const blue = Color(0xFF2962EF);
  static const ink = Color(0xFF192F52);

  int get _index {
    if (location.startsWith('/calculator')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/target') || location.startsWith('/progress')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _select(BuildContext context, int index) {
    const routes = ['/home', '/calculator', '/history', '/target', '/profile'];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    const tabs = <({IconData icon, String label})>[
      (icon: Icons.home_outlined, label: 'Beranda'),
      (icon: Icons.calculate_outlined, label: 'Kalkulator'),
      (icon: Icons.assignment_outlined, label: 'Riwayat'),
      (icon: Icons.track_changes_outlined, label: 'Target'),
      (icon: Icons.person_outline, label: 'Profil'),
    ];
    final selected = _index;
    final isHistory = location.startsWith('/history');
    final isGoal = location.startsWith('/target');
    final isProgress = location.startsWith('/progress');
    final isHome = location.startsWith('/home');

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar + navbar TIDAK tergulung bersama ListView halaman.
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 65,
        titleSpacing: 20,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/cekbmiku_logo_mark.png',
              width: 36,
              height: 39,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                isHistory ? 'Riwayat BMI' : isGoal ? 'Target BMIku' : isProgress ? 'ProgressBMIku' : 'CekBMIku',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        actions: (isHome || location == '/profile') ? [
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: () => context.push('/notifications'),
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: blue,
              size: 25,
            ),
          ),
          const SizedBox(width: 10),
        ] : null,
      ),
      body: child,
      // Navbar diletakkan di luar body, jadi posisi tetap ketika scroll.
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2EAF6))),
        ),
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Tetap proporsional pada layar kecil, tidak melebar di tablet.
              final compact = constraints.maxWidth < 360;
              final iconSize = compact ? 20.0 : 22.0;
              final labelSize = compact ? 9.4 : 10.5;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 5 : 12,
                  vertical: 8,
                ),
                child: Center(
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 630),
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final tab = tabs[index];
                        final active = selected == index;
                        return Expanded(
                          child: Semantics(
                            button: true,
                            selected: active,
                            label: tab.label,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _select(context, index),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: compact ? 40 : 46,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? const Color(0xFFEDF3FF)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(19),
                                      ),
                                      child: Icon(
                                        tab.icon,
                                        size: iconSize,
                                        color: blue,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      tab.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: labelSize,
                                        fontWeight: active
                                            ? FontWeight.w800
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
