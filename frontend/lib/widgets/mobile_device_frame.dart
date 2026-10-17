import 'package:flutter/material.dart';
import '../screens/exam_management_screen.dart';

class MobileDeviceFrame extends StatefulWidget {
  final Widget child;
  final String appTitle;
  final bool forceMobileOnly;

  const MobileDeviceFrame({
    super.key,
    required this.child,
    this.appTitle = 'TOEIC Student App',
    this.forceMobileOnly = false,
  });

  @override
  State<MobileDeviceFrame> createState() => _MobileDeviceFrameState();
}

class _MobileDeviceFrameState extends State<MobileDeviceFrame> {
  bool _useFrame = true; // Toggle between phone frame and full responsive view
  String _selectedDevice = 'iPhone 15 Pro'; // 'iPhone 15 Pro' or 'Samsung Galaxy'

  @override
  Widget build(BuildContext context) {
    if (widget.forceMobileOnly) {
      return widget.child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 650;

        // If screen is narrow (e.g. actual phone browser) or user disabled frame
        if (!isDesktop || !_useFrame) {
          return Stack(
            children: [
              widget.child,
              if (isDesktop && !_useFrame)
                Positioned(
                  top: 16,
                  right: 24,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFF0F172A),
                    child: InkWell(
                      onTap: () => setState(() => _useFrame = true),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone_iphone_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Bật Khung Điện Thoại',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }

        // Desktop presentation mode: Realistic Mobile Phone Shell
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A), // Dark slate aesthetic backdrop
          body: Column(
            children: [
              // 1. Desktop Top Presentation Bar
              _buildDesktopTopBar(context),

              // 2. Centered Smartphone Frame
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _buildSmartphoneMockup(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopTopBar(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          // App Indicator Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.phone_android_rounded, color: Color(0xFF60A5FA), size: 18),
                SizedBox(width: 8),
                Text(
                  'GIAO DIỆN SINH VIÊN (MOBILE APP ANDROID / IOS)',
                  style: TextStyle(
                    color: Color(0xFF93C5FD),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Device Switcher
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.devices_rounded, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedDevice,
                  underline: const SizedBox(),
                  dropdownColor: const Color(0xFF334155),
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  items: const [
                    DropdownMenuItem(value: 'iPhone 15 Pro', child: Text('iPhone 15 Pro')),
                    DropdownMenuItem(value: 'Samsung Galaxy', child: Text('Samsung Galaxy S24')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDevice = val);
                  },
                ),
              ],
            ),
          ),

          const Spacer(),

          // Fullscreen Toggle
          TextButton.icon(
            onPressed: () => setState(() => _useFrame = !_useFrame),
            icon: Icon(_useFrame ? Icons.fullscreen_rounded : Icons.phone_iphone_rounded, color: Colors.white70, size: 18),
            label: Text(
              _useFrame ? 'Xem Toàn Màn Hình' : 'Bật Khung Điện Thoại',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),

          const SizedBox(width: 16),

          // Portal Giáo Viên Button (High-Priority Direct CTA)
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExamManagementScreen()),
              );
            },
            icon: const Icon(Icons.school_rounded, size: 18),
            label: const Text('Portal Giáo Viên (Stitch Web)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartphoneMockup(BuildContext context) {
    const isIphone = true;
    final width = _selectedDevice.contains('iPhone') ? 412.0 : 400.0;
    final height = _selectedDevice.contains('iPhone') ? 850.0 : 840.0;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Outer phone body
        borderRadius: BorderRadius.circular(52),
        border: Border.all(color: const Color(0xFF475569), width: 3.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 40,
            spreadRadius: 8,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
            blurRadius: 60,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10), // Bezel width
      child: ClipRRect(
        borderRadius: BorderRadius.circular(42),
        child: Container(
          color: const Color(0xFFF8FAFC),
          child: Stack(
            children: [
              // The App Content Inside Phone Screen
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(top: 44, bottom: 20), // Space for status bar & home bar
                  child: widget.child,
                ),
              ),

              // Mobile Phone Status Bar (Top)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildPhoneStatusBar(isIphone),
              ),

              // Mobile Phone Home Indicator (Bottom)
              Positioned(
                bottom: 6,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 134,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneStatusBar(bool isIphone) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      color: Colors.white.withValues(alpha: 0.95),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          const Text(
            '9:41',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              letterSpacing: -0.2,
            ),
          ),

          // Dynamic Island Pill (iPhone style)
          if (isIphone)
            Container(
              width: 110,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E293B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),

          // System Icons (Signal, Wi-Fi, Battery)
          const Row(
            children: [
              Icon(Icons.signal_cellular_alt_rounded, size: 16, color: Color(0xFF0F172A)),
              SizedBox(width: 4),
              Icon(Icons.wifi_rounded, size: 16, color: Color(0xFF0F172A)),
              SizedBox(width: 6),
              Icon(Icons.battery_full_rounded, size: 20, color: Color(0xFF0F172A)),
            ],
          ),
        ],
      ),
    );
  }
}
