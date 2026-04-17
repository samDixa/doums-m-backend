import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String courseTitle;
  final String price;
  final String originalPrice;
  final String startDate;
  final String endDate;
  final String duration;

  const PaymentScreen({
    super.key,
    required this.courseTitle,
    required this.price,
    required this.originalPrice,
    required this.startDate,
    required this.endDate,
    required this.duration,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isDonationChecked = false;
  String _selectedPaymentMethod = 'UPI';

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
          'Payment',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Batch Summary', isUnderlined: true),
              const SizedBox(height: 16),
              _buildBatchSummaryCard(),
              const SizedBox(height: 20),
              _buildCouponSection(),
              const SizedBox(height: 16),
              _buildDonationSection(),
              const SizedBox(height: 20),
              _buildSectionTitle('Your Details'),
              const SizedBox(height: 12),
              _buildTextField('Student Name'),
              const SizedBox(height: 12),
              _buildTextField('Studentname123@gmail.com'),
              const SizedBox(height: 12),
              _buildTextField('+91 987654321'),
              const SizedBox(height: 24),
              _buildSectionTitle('Payment Method'),
              const SizedBox(height: 12),
              _buildPaymentMethods(),
              const SizedBox(height: 24),
              _buildSectionTitle('Payment Summary'),
              const SizedBox(height: 12),
              _buildPaymentSummary(),
              const SizedBox(height: 40),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool isUnderlined = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        if (isUnderlined)
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 140,
              color: const Color(0xFF1B3B5F),
            ),
          ),
      ],
    );
  }

  Widget _buildBatchSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://i.ibb.co/vzY3qGq/new-badge.png', // Placeholder for batch image
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.class_, size: 50, color: Colors.blueGrey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.courseTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Batch Duration: ${widget.duration}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                Text('Starts: ${widget.startDate}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                Text('Ends: ${widget.endDate}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      widget.originalPrice,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Apply Code/Coupon',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text(
              'Apply Coupon Code',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Donate to AIM Homeopathy',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            '₹10',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Checkbox(
            value: _isDonationChecked,
            onChanged: (val) => setState(() => _isDonationChecked = val ?? false),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          _buildPaymentOption('UPI', Icons.diamond_outlined),
          _buildPaymentOption('Debit/Credit Card', Icons.diamond_outlined),
          _buildPaymentOption('Net Banking', Icons.diamond_outlined),
          _buildPaymentOption('Wallets', Icons.diamond_outlined),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    bool isSelected = _selectedPaymentMethod == title;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: title != 'Wallets' ? Border(bottom: BorderSide(color: Colors.grey.shade300)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      children: [
        const Divider(color: Colors.black, thickness: 1),
        const SizedBox(height: 8),
        _buildSummaryRow('Price', widget.originalPrice, isBoldValue: true),
        const SizedBox(height: 8),
        _buildSummaryRow('Item Discount', '-₹5001', valueColor: Colors.green),
        const SizedBox(height: 8),
        _buildSummaryRow('Delivery Charge', '₹0'),
        const SizedBox(height: 8),
        _buildSummaryRow('Coupon Discount', '-₹0', valueColor: Colors.green),
        const SizedBox(height: 12),
        const Divider(color: Colors.black, thickness: 1),
        const SizedBox(height: 8),
        _buildSummaryRow('Total Amount', widget.price, isBoldLabel: true, isBoldValue: true, fontSize: 18),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {Color? valueColor,
      bool isBoldLabel = false,
      bool isBoldValue = false,
      double fontSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBoldLabel ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: fontSize,
              color: valueColor ?? Colors.black,
              fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.grey.shade200,
      child: const Center(
        child: Text(
          'Trusted and Secure Payment',
          style: TextStyle(
              color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
