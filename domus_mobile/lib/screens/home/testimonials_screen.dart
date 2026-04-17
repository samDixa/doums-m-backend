import 'package:flutter/material.dart';

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({super.key});

  final List<Map<String, dynamic>> _profiles = const [
    {
      'name': 'A - Doctor Profile 1',
      'image': 'https://i.pravatar.cc/150?img=11',
      'subject': 'Biology',
      'qualification': 'MBBS, MD (Physiology)',
      'experience': '8+ years of teaching NEET aspirants',
      'specialization': 'Human Physiology & Genetics',
      'teachingStyle': 'Concept-based learning with real-life examples',
      'achievements': [
        'Mentored 5000+ students',
        '200+ NEET selections under his guidance',
        'Guest Lecturer at Medical Entrance Seminars',
      ]
    },
    {
      'name': 'A - Doctor Profile 1',
      'image': 'https://i.pravatar.cc/150?img=11',
      'subject': 'Biology',
      'qualification': 'MBBS, MD (Physiology)',
      'experience': '8+ years of teaching NEET aspirants',
      'specialization': 'Human Physiology & Genetics',
      'teachingStyle': 'Concept-based learning with real-life examples',
      'achievements': [
        'Mentored 5000+ students',
        '200+ NEET selections under his guidance',
        'Guest Lecturer at Medical Entrance Seminars',
      ]
    },
    {
      'name': 'A - Doctor Profile 1',
      'image': 'https://i.pravatar.cc/150?img=11',
      'subject': 'Biology',
      'qualification': 'MBBS, MD (Physiology)',
      'experience': '8+ years of teaching NEET aspirants',
      'specialization': 'Human Physiology & Genetics',
      'teachingStyle': 'Concept-based learning with real-life examples',
      'achievements': [
        'Mentored 5000+ students',
        '200+ NEET selections under his guidance',
        'Guest Lecturer at Medical Entrance Seminars',
      ]
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
        title: const Text('Testimonials', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F7FA), // Soft grey background as per design
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ListView.builder(
          itemCount: _profiles.length,
          itemBuilder: (context, index) {
            return _buildProfileCard(_profiles[index]);
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  data['image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  data['name'],
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Details
          _buildTableRow('Subject', data['subject']),
          _buildTableRow('Qualification', data['qualification']),
          _buildTableRow('Experience', data['experience']),
          _buildTableRow('Specialization', data['specialization']),
          _buildTableRow('Teaching Style', data['teachingStyle']),
          
          const SizedBox(height: 8),
          
          // Achievements
          const Text('Achievements:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
          const SizedBox(height: 4),
          for (String achievement in data['achievements'])
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(achievement, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
            ),
          ),
          const Text(' : ', style: TextStyle(fontSize: 13, color: Colors.black)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
