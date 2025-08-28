import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'payment_page.dart';

class CustomerDetailsPage extends StatefulWidget {
  const CustomerDetailsPage({super.key, required this.productName, required this.quantity, required this.totalPrice});
  final String productName;
  final int quantity;
  final double totalPrice;

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF6F7FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator
              Row(
                children: const [
                  _StepDot(active: true, label: 'Details'),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded, color: Colors.black26),
                  SizedBox(width: 8),
                  _StepDot(active: false, label: 'Payment'),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.productName, style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('Qty: ${widget.quantity}', style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFFFF1E6), borderRadius: BorderRadius.circular(10)),
                      child: Text('\$${widget.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFFF7A00))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _field('Full Name', _nameCtrl, icon: Icons.person_outline, textInputAction: TextInputAction.next, validator: (v) => v == null || v.trim().isEmpty ? 'Enter your name' : null),
              _field('Email', _emailCtrl, icon: Icons.mail_outline, textInputAction: TextInputAction.next, keyboardType: TextInputType.emailAddress, validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter your email';
                final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
                return ok ? null : 'Enter a valid email';
              }),
              _field('Phone Number', _phoneCtrl, icon: Icons.phone_outlined, textInputAction: TextInputAction.next, keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => v == null || v.trim().length < 7 ? 'Enter a valid phone' : null),
              _field('Home Address', _addressCtrl, icon: Icons.home_outlined, maxLines: 3, textInputAction: TextInputAction.newline, validator: (v) => v == null || v.trim().length < 5 ? 'Enter your address' : null),
              _field('Notes (optional)', _notesCtrl, icon: Icons.sticky_note_2_outlined, maxLines: 3),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentPage(total: widget.totalPrice),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A00),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Next', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {IconData? icon, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters, TextInputAction? textInputAction, int maxLines = 1, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.active, required this.label});
  final bool active;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFF7A00) : Colors.black26,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: active ? Colors.black87 : Colors.black45, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
