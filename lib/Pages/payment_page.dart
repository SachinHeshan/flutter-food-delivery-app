import 'package:flutter/material.dart';

enum PaymentMethod { cash, visa, mastercard, paypal }

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.total});
  final double total;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod selected = PaymentMethod.mastercard;

  final GlobalKey<FormState> _cardFormKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberCtrl = TextEditingController();
  final TextEditingController _cardNameCtrl = TextEditingController();
  final TextEditingController _expiryCtrl = TextEditingController();
  final TextEditingController _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  bool get _isCardValid {
    if (!(selected == PaymentMethod.visa || selected == PaymentMethod.mastercard)) return true;
    return _cardFormKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF6F7FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select payment method', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            _methodsRow(),
            const SizedBox(height: 16),
            if (selected == PaymentMethod.visa || selected == PaymentMethod.mastercard)
              _cardForm()
            else
              _methodInfoCard(),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('TOTAL:', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Text('\$${widget.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isCardValid ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A00),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                selected == PaymentMethod.cash || selected == PaymentMethod.paypal ? 'PAY & CONFIRM' : 'PAY & CONFIRM',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _methodsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _methodTile(PaymentMethod.cash, Icons.payments_outlined, 'Cash'),
          const SizedBox(width: 10),
          _methodTile(PaymentMethod.visa, Icons.credit_card, 'Visa'),
          const SizedBox(width: 10),
          _methodTile(PaymentMethod.mastercard, Icons.credit_card_rounded, 'Mastercard', showTick: true),
          const SizedBox(width: 10),
          _methodTile(PaymentMethod.paypal, Icons.account_balance_wallet_outlined, 'PayPal'),
        ],
      ),
    );
  }

  Widget _methodTile(PaymentMethod method, IconData icon, String label, {bool showTick = false}) {
    final bool isSelected = selected == method;
    return InkWell(
      onTap: () => setState(() => selected = method),
      child: Container(
        width: 110,
        height: 74,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFEFF1F6),
          borderRadius: BorderRadius.circular(14),
          border: isSelected ? Border.all(color: const Color(0xFFFF7A00), width: 1.5) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 6))]
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.black54),
                  const SizedBox(height: 6),
                  Text(label, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            if (isSelected && showTick)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.check_circle, color: Color(0xFFFF7A00), size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _methodInfoCard() {
    String title;
    String message;
    IconData icon;
    switch (selected) {
      case PaymentMethod.cash:
        title = 'Cash on delivery';
        message = 'Pay in cash when you receive your order.';
        icon = Icons.payments_outlined;
        break;
      case PaymentMethod.paypal:
        title = 'Pay with PayPal';
        message = 'You will be redirected to PayPal to complete payment.';
        icon = Icons.account_balance_wallet_outlined;
        break;
      default:
        title = '';
        message = '';
        icon = Icons.info_outline;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: const Color(0xFFFF7A00)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(message, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Form(
        key: _cardFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(selected == PaymentMethod.visa ? Icons.credit_card : Icons.credit_card_rounded, color: const Color(0xFFFF7A00)),
                const SizedBox(width: 8),
                Text(selected == PaymentMethod.visa ? 'Visa Card' : 'Mastercard', style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cardNumberCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Card Number',
                prefixIcon: const Icon(Icons.numbers),
                filled: true,
                fillColor: const Color(0xFFFDFDFE),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              validator: (v) => v == null || v.replaceAll(' ', '').length < 12 ? 'Enter a valid card number' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cardNameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Name on Card',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: const Color(0xFFFDFDFE),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter cardholder name' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryCtrl,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Expiry (MM/YY)',
                      prefixIcon: const Icon(Icons.event),
                      filled: true,
                      fillColor: const Color(0xFFFDFDFE),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    validator: (v) => v == null || !RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})$').hasMatch(v) ? 'MM/YY' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cvvCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: const Color(0xFFFDFDFE),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    validator: (v) => v == null || v.length < 3 ? '3-4 digits' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
