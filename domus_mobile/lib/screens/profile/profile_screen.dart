import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:domus_mobile/core/constants/api_constants.dart';
import 'package:domus_mobile/viewmodels/auth/auth_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;

    return Scaffold(
      backgroundColor: const Color(0xFF021B3A),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (ref.watch(authNotifierProvider).isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    ),
                ],
              ),
            ),

            // Profile Picture Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                    GestureDetector(
                      onTap: () => _pickAndUploadImage(context, ref),
                      behavior: HitTestBehavior.opaque,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: user?.profileImage != null 
                                  ? CachedNetworkImageProvider('${ApiConstants.baseUrl}${user!.profileImage}') 
                                  : null,
                              child: user?.profileImage == null 
                                  ? const Icon(Icons.person, size: 80, color: Color(0xFF021B3A))
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.edit, size: 16, color: Color(0xFF021B3A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _pickAndUploadImage(context, ref),
                      behavior: HitTestBehavior.opaque,
                      child: const Text(
                        'Change Profile Picture',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info Sections
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Medicos Info'),
                      _buildInfoField('First Name', user?.firstName ?? 'N/A', Icons.edit, 
                        onTap: () => _showEditDialog(context, ref, 'First Name', user?.firstName ?? '', 'first_name')),
                      _buildInfoField('Last Name', user?.lastName ?? 'N/A', Icons.edit, 
                        onTap: () => _showEditDialog(context, ref, 'Last Name', user?.lastName ?? '', 'last_name')),
                      _buildInfoField('Mobile Number', user?.phone ?? 'N/A', Icons.info_outline), // Usually read-only
                      _buildInfoField('Email', user?.email ?? 'N/A', Icons.edit, 
                        onTap: () => _showEditDialog(context, ref, 'Email', user?.email ?? '', 'email')),
                      _buildInfoField('Year/Batch', user?.batch ?? 'N/A', Icons.edit, 
                        onTap: () => _showEditDialog(context, ref, 'Year/Batch', user?.batch ?? '', 'batch')),
                      _buildInfoField('U.G. College', user?.ugCollegeName ?? 'N/A', Icons.edit, 
                        onTap: () => _showEditDialog(context, ref, 'U.G. College', user?.ugCollegeName ?? '', 'ug_college_name')),
                      _buildInfoField('P.G. College', 'N/A', Icons.info_outline),
                      
                      const SizedBox(height: 20),
                      _buildSectionHeader('Other Details'),
                      _buildInfoField('Date of Birth', user?.dob ?? 'N/A', Icons.info_outline, 
                         onTap: () => _showEditDialog(context, ref, 'Date of Birth', user?.dob ?? '', 'dob')),
                      _buildInfoField('U.G. College State', user?.ugCollegeState ?? 'N/A', Icons.edit, 
                        onTap: () => _showEditDialog(context, ref, 'U.G. College State', user?.ugCollegeState ?? '', 'ug_college_state')),
                      _buildInfoField('P.G. College state', 'N/A', Icons.info_outline),
                      _buildInfoField('Domicile State', user?.state ?? 'N/A', Icons.edit, 
                        onTap: () => _showEditDialog(context, ref, 'Domicile State', user?.state ?? '', 'state')),
                      _buildInfoField('Gender', user?.gender ?? 'N/A', Icons.edit, 
                        onTap: () => _showEditDialog(context, ref, 'Gender', user?.gender ?? '', 'gender')),

                      const SizedBox(height: 20),
                      _buildSectionHeader('Delete Account'),
                      _buildDeleteButton(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context, WidgetRef ref) async {
    debugPrint('Pick image triggered...');
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      debugPrint('Image picked: ${image?.path}');
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        await ref.read(authNotifierProvider.notifier).uploadProfilePhoto(bytes, image.name);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile photo uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildInfoField(String label, String value, IconData icon, {VoidCallback? onTap}) {
    bool hasData = value != 'N/A' && value.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (hasData)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(icon, color: icon == Icons.edit ? const Color(0xFF021B3A) : Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, String label, String currentValue, String fieldKey) {
    if (fieldKey == 'dob') {
        _selectDate(context, ref, currentValue);
        return;
    }

    final controller = TextEditingController(text: currentValue == 'N/A' ? '' : currentValue);
    TextInputType keyboardType = TextInputType.text;
    if (fieldKey == 'batch') {
        keyboardType = TextInputType.number;
    } else if (fieldKey == 'email') {
        keyboardType = TextInputType.emailAddress;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(
          'Edit $label',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF021B3A)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: 'Enter $label',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              final newValue = controller.text.trim();
              if (newValue != currentValue) {
                await ref.read(authNotifierProvider.notifier).updateProfile({
                  fieldKey: newValue,
                });
              }
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF021B3A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref, String currentValue) async {
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 20));
    try {
        if (currentValue != 'N/A' && currentValue.isNotEmpty) {
            initialDate = DateTime.parse(currentValue);
        }
    } catch (_) {}

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        builder: (context, child) {
            return Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                        primary: Color(0xFF021B3A),
                        onPrimary: Colors.white,
                        onSurface: Color(0xFF021B3A),
                    ),
                    textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(foregroundColor: const Color(0xFF021B3A)),
                    ),
                ),
                child: child!,
            );
        },
    );

    if (picked != null) {
        final formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        await ref.read(authNotifierProvider.notifier).updateProfile({
            'dob': formattedDate,
        });
    }
  }

  Widget _buildDeleteButton() {
     return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Remove All Data From AIM Homoeopathy.',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.delete_outline, color: Colors.black, size: 24),
        ],
      ),
    );
  }
}
