import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QOTDScreen extends StatefulWidget {
  const QOTDScreen({super.key});

  @override
  State<QOTDScreen> createState() => _QOTDScreenState();
}

class _QOTDScreenState extends State<QOTDScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ["Ques of Day", "Clinical Case", "Opinion Poll"];

  final List<Map<String, String>> _questions = [
    {
      'image': 'https://logo.clearbit.com/shopee.com',
      'question': 'An electron and alpha particle have the same de-Broglie wavelength associated with them. How are their kinetic energies related to each other? (Delhi 2008)',
      'date': '04 May 2025'
    },
    {
      'image': 'https://logo.clearbit.com/pg.com',
      'question': 'An electron and alpha particle have the same de-Broglie wavelength associated with them. How are their kinetic energies related to each other? (Delhi 2008)',
      'date': '04 May 2025'
    },
    {
      'image': 'https://logo.clearbit.com/bmw.com',
      'question': 'An electron and alpha particle have the same de-Broglie wavelength associated with them. How are their kinetic energies related to each other? (Delhi 2008)',
      'date': '04 May 2025'
    },
    {
      'image': 'https://logo.clearbit.com/apple.com',
      'question': 'An electron and alpha particle have the same de-Broglie wavelength associated with them. How are their kinetic energies related to each other? (Delhi 2008)',
      'date': '04 May 2025'
    },
    {
      'image': 'https://logo.clearbit.com/huawei.com',
      'question': 'An electron and alpha particle have the same de-Broglie wavelength associated with them. How are their kinetic energies related to each other? (Delhi 2008)',
      'date': '04 May 2025'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021B3A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('QOTD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.tune, color: Colors.black54, size: 20),
                  SizedBox(width: 4),
                  Text('Filter', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Tabs
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedTabIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEAF2F8) : Colors.white,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF1B3B5F) : Colors.grey.shade400,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _tabs[index],
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF1B3B5F) : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            
            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return _buildListCard(_questions[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(Map<String, String> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3B5F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Image
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                data['image']!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Right Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['question']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Date: ${data['date']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.bookmark_border, color: Colors.white, size: 22),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
