import 'package:flutter/material.dart';
import '../../models/job_model.dart';

class JobPortalScreen extends StatefulWidget {
  const JobPortalScreen({super.key});

  @override
  State<JobPortalScreen> createState() => _JobPortalScreenState();
}

class _JobPortalScreenState extends State<JobPortalScreen> {
  String? _selectedState;
  final List<String> _states = [
    'Madhya Pradesh',
    'Uttar Pradesh',
    'Rajasthan',
    'Delhi',
    'Maharashtra',
    'Bihar',
    'Gujarat'
  ];

  final List<JobModel> _allJobs = [
    JobModel(
      title: 'Food Safety Officer Recruitment in Madhya Pradesh : MPPSC',
      brandedIcon: 'assets/icons/domus/dominos_logo.png',
      state: 'Madhya Pradesh',
    ),
    JobModel(
      title: 'Food Safety Officer Recruitment in Madhya Pradesh : MPPSC',
      brandedIcon: 'assets/icons/domus/mcdonalds_logo.png',
      state: 'Madhya Pradesh',
    ),
    JobModel(
      title: 'Ayush Medical Officer Recruitment in Uttar Pradesh',
      brandedIcon: 'assets/icons/domus/belle_logo.png',
      state: 'Uttar Pradesh',
    ),
    JobModel(
      title: 'Homoeopathic Medical Officer in Rajasthan',
      brandedIcon: 'assets/icons/domus/huawei_logo.png',
      state: 'Rajasthan',
    ),
    JobModel(
      title: 'Medical Officer Recruitment in Delhi : UPSC',
      brandedIcon: 'assets/icons/domus/nasa_logo.png',
      state: 'Delhi',
    ),
  ];

  List<JobModel> get _filteredJobs {
    if (_selectedState == null || _selectedState == 'All') {
      return _allJobs;
    }
    return _allJobs.where((job) => job.state == _selectedState).toList();
  }

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
        title: const Text(
          'Job Portal',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildFilters(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredJobs.length,
                itemBuilder: (context, index) {
                  return _buildJobCard(_filteredJobs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // All Button
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => setState(() => _selectedState = 'All'),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: (_selectedState == null || _selectedState == 'All')
                      ? const Color(0xFFE8F0F8)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1B3B5F), width: 1),
                ),
                child: const Center(
                  child: Text(
                    'All',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // State Dropdown
          Expanded(
            flex: 3,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: (_selectedState != 'All') ? _selectedState : null,
                  hint: const Text('Select Your State'),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  items: _states.map((String state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _selectedState = val);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobModel job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3B5F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              job.brandedIcon,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.business, color: Colors.blueGrey),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              job.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
