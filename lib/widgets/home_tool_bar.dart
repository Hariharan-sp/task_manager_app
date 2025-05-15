import 'package:flutter/material.dart';

class HomeToolBar extends StatelessWidget {
  final String title;
  final bool showBackButton;

  const HomeToolBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Icon(Icons.wifi, color: Colors.grey[700]),
              const SizedBox(width: 8),
              const Badge(
                child: Icon(Icons.notifications_none),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/user_avatar.png'),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
