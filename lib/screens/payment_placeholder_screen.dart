import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/mock_api_service.dart';
import 'order_success_screen.dart';

class PaymentPlaceholderScreen extends StatefulWidget {
  final OrderData orderData;

  const PaymentPlaceholderScreen({Key? key, required this.orderData})
      : super(key: key);

  @override
  State<PaymentPlaceholderScreen> createState() =>
      _PaymentPlaceholderScreenState();
}

class _PaymentPlaceholderScreenState extends State<PaymentPlaceholderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isProcessing = true;
  String _statusMessage = 'Ödeme işlemi başlatılıyor...';
  int _currentStep = 0;

  final List<String> _steps = [
    'Ödeme işlemi başlatılıyor...',
    'PayTr ile bağlantı kuruluyor...',
    'Sipariş bilgileri doğrulanıyor...',
    'Ödeme onaylanıyor...',
    'Siparişler kaydediliyor...',
    'İşlem tamamlandı!'
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.repeat(reverse: true);
    _startPaymentProcess();
  }

  Future<void> _startPaymentProcess() async {
    for (int i = 0; i < _steps.length; i++) {
      if (mounted) {
        setState(() {
          _currentStep = i;
          _statusMessage = _steps[i];
        });
      }

      await Future.delayed(const Duration(milliseconds: 800));
    }

    // Siparişleri veritabanına kaydet
    await _submitOrders();
  }

  Future<void> _submitOrders() async {
    try {
      // Script siparişlerini kaydet
      final scriptOrders = widget.orderData.toScriptOrders();
      for (var scriptOrder in scriptOrders) {
        await MockApiService.createOrder(scriptOrder);
      }

      // Hosting siparişlerini kaydet
      final hostingOrders = widget.orderData.toHostingOrders();
      for (var hostingOrder in hostingOrders) {
        await MockApiService.createHostingOrder(hostingOrder);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderSuccessScreen(orderData: widget.orderData),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Ödeme işlemi başarısız oldu';
        });

        _showErrorDialog(e.toString());
      }
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red[600]),
            const SizedBox(width: 8),
            const Text('Ödeme Hatası'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ödeme işlemi sırasında bir hata oluştu:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Text(
                error,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[800],
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // önce Dialogu kapat
              Navigator.of(context).pop(); // sonra Payment screeni kapat
            },
            child: const Text('Geri Dön'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startPaymentProcess();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
            child: const Text('Tekrar Dene',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  if (!_isProcessing)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  const Spacer(),
                  Text(
                    'PayTr Ödeme',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  if (!_isProcessing) const SizedBox(width: 48), // Balance için
                ],
              ),

              const SizedBox(height: 40),

              // Ana içerik
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // PayTr Logo Placeholder
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.payment,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // PayTr Placeholder Text
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: Colors.blue[600]),
                          const SizedBox(width: 8),
                          Text(
                            'PayTr Entegrasyonu Simülasyonu',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Durum mesajı
                    Text(
                      _statusMessage,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Progress indicator
                    if (_isProcessing) ...[
                      SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          value: (_currentStep + 1) / _steps.length,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Adım ${_currentStep + 1} / ${_steps.length}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),

                    // Sipariş özeti
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.receipt_long,
                                  color: Colors.grey[600], size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Sipariş Özeti',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Toplam Ürün:',
                                  style: TextStyle(color: Colors.grey[600])),
                              Text(
                                  '${widget.orderData.getOrderSummary()['total_items']} adet'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tutar:',
                                  style: TextStyle(color: Colors.grey[600])),
                              Text(
                                '${widget.orderData.grandTotal.toStringAsFixed(0)}₺',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Alt bilgi
              if (_isProcessing) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber,
                          color: Colors.orange[600], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Bu sayfayı kapatmayın. İşlem tamamlanıncaya kadar bekleyiniz.',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
