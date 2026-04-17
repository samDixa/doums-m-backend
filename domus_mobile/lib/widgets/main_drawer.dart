import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domus_mobile/viewmodels/auth/auth_notifier.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:domus_mobile/screens/auth/login_screen.dart';
import 'package:domus_mobile/screens/profile/profile_screen.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: const Color(0xFF021B3A),
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        child: Column(
          children: [
            // Close button and Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  const _DrawerLogo(),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('My Details'),
                    _buildDrawerItem(Icons.person, 'Profile', Colors.white, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    }),
                    _buildDrawerItem(Icons.bookmark, 'Bookmarks', Colors.red, () {}),
                    _buildDrawerItem(Icons.lightbulb, 'Quick Fact', Colors.yellow, () {}),
                    
                    const Divider(color: Colors.white24, indent: 20, endIndent: 20),
                    
                    _buildSectionHeader('Miscellaneous'),
                    _buildDrawerItem(Icons.chat_bubble, 'Testimonials', Colors.grey, () {}),
                    _buildDrawerItem(Icons.campaign, 'Homoeopathic Events', Colors.redAccent, () {}),
                    _buildDrawerItem(Icons.groups, 'Homoeo Community', Colors.green, () {}),
                    _buildDrawerItem(Icons.card_membership, 'AIM Academy', Colors.orange, () {}),
                    _buildDrawerItem(Icons.notifications, 'Notification', Colors.orangeAccent, () {}),
                    
                    const Divider(color: Colors.white24, indent: 20, endIndent: 20),
                    
                    _buildSectionHeader('About Us'),
                    _buildDrawerItem(Icons.stars, 'Rate', Colors.red, () {}),
                    _buildDrawerItem(Icons.share, 'Share', Colors.purple, () {}),
                    _buildDrawerItem(Icons.feedback, 'Feedback', Colors.blue, () {}),
                    _buildDrawerItem(Icons.group, 'AIM Team', Colors.teal, () {}),
                    _buildDrawerItem(Icons.info, 'About', Colors.blueAccent, () {}),
                    
                    const Divider(color: Colors.white24, indent: 20, endIndent: 20),
                    
                    _buildSectionHeader('Contact Us'),
                    _buildDrawerItem(FontAwesomeIcons.envelope, 'Gmail', Colors.orange, () {}),
                    _buildDrawerItem(FontAwesomeIcons.facebook, 'Facebook', Colors.blue[800]!, () {}),
                    _buildDrawerItem(FontAwesomeIcons.instagram, 'Instagram', Colors.pink, () {}),
                    _buildDrawerItem(FontAwesomeIcons.telegram, 'Telegram', Colors.lightBlue, () {}),
                    _buildDrawerItem(FontAwesomeIcons.youtube, 'YouTube', Colors.red, () {}),
                    _buildDrawerItem(FontAwesomeIcons.whatsapp, 'Whatsapp', Colors.green, () {}),
                    
                    const SizedBox(height: 30),
                    
                    // Logout Option at the bottom of the list
                    _buildDrawerItem(Icons.logout, 'Logout', Colors.white, () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                             TextButton(
                               onPressed: () async {
                                 Navigator.pop(context); // Close dialog
                                 Navigator.pop(context); // Close drawer
                                 await ref.read(authNotifierProvider.notifier).logout();
                                 if (context.mounted) {
                                   Navigator.of(context).pushAndRemoveUntil(
                                     MaterialPageRoute(builder: (context) => const LoginScreen()),
                                     (route) => false,
                                   );
                                 }
                               },
                               child: const Text('Logout', style: TextStyle(color: Colors.red)),
                             ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(dynamic icon, String title, Color iconColor, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
      leading: icon is IconData 
        ? Icon(icon, color: iconColor, size: 24)
        : FaIcon(icon as IconData, color: iconColor, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _DrawerLogo extends StatelessWidget {
  const _DrawerLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DOMUS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'HOMOEOPATHICA',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
