import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/order_controller.dart';
import '../../../../models/order_model.dart';
import '../../../../core/helpers.dart';

class OrderHistoryScreen extends StatefulWidget {
  final String customerId;
  final String? customerName;
  const OrderHistoryScreen({
    super.key,
    required this.customerId,
    this.customerName,
  });

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();

    // Capture controller synchronously, then await in a post-frame callback.
    final orderCtrl = context.read<OrderController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await orderCtrl.fetchOrders(widget.customerId);
      if (!mounted) return;
      setState(() => _initialLoading = false);
    });
  }

  Future<void> _refresh(BuildContext context) async {
    await context.read<OrderController>().fetchOrders(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    final orderCtrl = context.watch<OrderController>();
    final isLoading = orderCtrl.isLoading || _initialLoading;
    final orders = orderCtrl.orders;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customerName == null
              ? 'Orders'
              : 'Orders • ${widget.customerName}',
        ),
      ),
      body: isLoading
      // 🔒 Show ONLY a spinner while fetching — no data behind it.
          ? const Center(child: CircularProgressIndicator())
          : (orders.isEmpty
          ? RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Center(child: Text('No orders found.')),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, idx) {
            final Order o = orders[idx];
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              title: Text(
                '${formatDate(o.orderDate)} → ${formatDate(o.deliveryDate)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(o.notes.isNotEmpty ? o.notes : 'No notes'),
                ],
              ),
              trailing: Chip(
                label: Text(o.status),
                backgroundColor: o.status.toLowerCase() == 'completed'
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
              ),
            );
          },
        ),
      )),
    );
  }
}
