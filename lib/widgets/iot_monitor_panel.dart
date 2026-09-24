import 'package:flutter/material.dart';

class IotMonitorPanel extends StatelessWidget {
  final List<String> logs;
  final bool isActive;

  const IotMonitorPanel({
    super.key,
    required this.logs,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green.shade400 : Colors.grey.shade700,
          width: 2,
        ),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.terminal,
                color: isActive ? Colors.green.shade400 : Colors.grey,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'MONITOR SERIAL IoT',
                style: TextStyle(
                  color: isActive ? Colors.green.shade400 : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.greenAccent : Colors.redAccent,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 16),
          ...logs.map((log) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  '> $log',
                  style: const TextStyle(
                    color: Color(0xFF00FF00),
                    fontFamily: 'Courier',
                    fontSize: 13,
                  ),
                ),
              )),
          if (logs.isEmpty)
            const Text(
              '> Aguardando dados do sensor...',
              style: TextStyle(
                color: Colors.white54,
                fontFamily: 'Courier',
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}