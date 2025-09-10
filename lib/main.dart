import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Configurar Aromatizador',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AromatizadorScreen(),
    );
  }
}

class AromatizadorScreen extends StatefulWidget {
  const AromatizadorScreen({super.key});

  @override
  State<AromatizadorScreen> createState() => _AromatizadorScreenState();
}

class _AromatizadorScreenState extends State<AromatizadorScreen> {
  bool isConnected = false;
  String statusMessage = 'Desconectado';
  int intensidade = 50;
  int intervalo = 30;
  bool isScanning = false;

  void _toggleConnection() {
    setState(() {
      isConnected = !isConnected;
      statusMessage = isConnected
          ? 'Conectado ao Aromatizador'
          : 'Desconectado';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isConnected ? 'Conectado com sucesso!' : 'Desconectado'),
        backgroundColor: isConnected ? Colors.green : Colors.orange,
      ),
    );
  }

  void _startScanning() {
    setState(() {
      isScanning = true;
      statusMessage = 'Procurando dispositivos...';
    });

    // Simular busca por dispositivos
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isScanning = false;
        statusMessage = 'Aromatizador encontrado!';
      });
    });
  }

  void _sendConfiguration() {
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conecte-se primeiro ao dispositivo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Configuração enviada: Intensidade $intensidade%, Intervalo ${intervalo}min',
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controlador Aromatizador'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      isConnected
                          ? Icons.bluetooth_connected
                          : Icons.bluetooth_disabled,
                      size: 48,
                      color: isConnected ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      statusMessage,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botões de Controle
            ElevatedButton.icon(
              onPressed: isScanning ? null : _startScanning,
              icon: isScanning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(isScanning ? 'Procurando...' : 'Buscar Dispositivo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _toggleConnection,
              icon: Icon(
                isConnected ? Icons.bluetooth_disabled : Icons.bluetooth,
              ),
              label: Text(isConnected ? 'Desconectar' : 'Conectar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: isConnected ? Colors.orange : Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            // Configurações
            Text(
              'Configurações',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Intensidade: $intensidade%'),
                    Slider(
                      value: intensidade.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          intensidade = value.round();
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    Text('Intervalo: ${intervalo} minutos'),
                    Slider(
                      value: intervalo.toDouble(),
                      min: 5,
                      max: 120,
                      divisions: 23,
                      onChanged: (value) {
                        setState(() {
                          intervalo = value.round();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _sendConfiguration,
              icon: const Icon(Icons.send),
              label: const Text('Enviar Configuração'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),

            const Spacer(),

            Text(
              'Versão: 1.1.4 (Modo Simulação)',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
