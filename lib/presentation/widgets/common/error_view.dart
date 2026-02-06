import 'package:flutter/material.dart';
import 'no_internet_screen.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool isConnectionError;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.isConnectionError = false,
  });

  @override
  Widget build(BuildContext context) {
    // Detect typical connection error keywords case-insensitively
    final lowerMsg = message.toLowerCase();
    final bool isOffline =
        isConnectionError ||
        lowerMsg.contains('host lookup') ||
        lowerMsg.contains('connection errored') ||
        lowerMsg.contains('socketexception') ||
        lowerMsg.contains('dioexception') ||
        lowerMsg.contains('network is unreachable') ||
        lowerMsg.contains('connection refused') ||
        lowerMsg.contains('connection closed') ||
        lowerMsg.contains('connection timed out');

    if (isOffline) {
      return NoInternetScreen(onRetry: onRetry);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              "Oops! Something went wrong",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _cleanMessage(message),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _cleanMessage(String msg) {
    // Strip redundant "Exception:" or known noisy prefixes if needed
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    return msg;
  }
}
