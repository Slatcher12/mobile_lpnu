import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Магічний Лічильник',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Магічний Лічильник'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  final TextEditingController _textController = TextEditingController();
  String _message = '';
  Color _messageColor = Colors.black;
  Color _backgroundColor = Colors.deepPurple;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _message = '';
    });
  }

  void _processInput() {
    final String input = _textController.text.trim();

    setState(() {
      if (input.isEmpty) {
        _message = 'Введіть щось! ✨';
        _messageColor = Colors.orange;
        return;
      }

      // Магічне заклинання: Avada Kedavra - скидає до 0
      if (input.toLowerCase() == 'avada kedavra') {
        _counter = 0;
        _message = '💀 Авада Кедавра! Лічильник знищено!';
        _messageColor = Colors.red;
        _animationController.forward().then((_) => _animationController.reverse());
        _textController.clear();
        return;
      }

      // Магічне заклинання: Wingardium Leviosa - подвоює
      if (input.toLowerCase() == 'wingardium leviosa') {
        _counter = _counter * 2;
        _message = '🪄 Вінгардіум Левіоса! Лічильник злетів удвічі!';
        _messageColor = Colors.blue;
        _animationController.forward().then((_) => _animationController.reverse());
        _textController.clear();
        return;
      }

      // Магічне заклинання: Lumos - змінює колір теми
      if (input.toLowerCase() == 'lumos') {
        _backgroundColor = _backgroundColor == Colors.deepPurple
            ? Colors.amber
            : Colors.deepPurple;
        _message = '💡 Люмос! Світло змінилося!';
        _messageColor = Colors.yellow.shade700;
        _textController.clear();
        return;
      }

      // Магічне заклинання: Nox - скидає колір
      if (input.toLowerCase() == 'nox') {
        _backgroundColor = Colors.deepPurple;
        _message = '🌑 Нокс! Світло згасло!';
        _messageColor = Colors.grey.shade700;
        _textController.clear();
        return;
      }

      // Спроба конвертувати в число
      final int? number = int.tryParse(input);
      if (number != null) {
        _counter += number;
        _message = number > 0
            ? '✅ Додано $number до лічильника!'
            : '✅ Віднято ${number.abs()} від лічильника!';
        _messageColor = Colors.green;
        _textController.clear();
      } else {
        _message = '❌ Невідоме заклинання або число! Спробуйте:\n'
            '• Число (наприклад: 5)\n'
            '• Avada Kedavra\n'
            '• Wingardium Leviosa\n'
            '• Lumos / Nox';
        _messageColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🪄 Магічний Лічильник',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Поточне значення:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: _backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Введіть число або заклинання',
                        hintText: 'Наприклад: 5 або Lumos',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.auto_fix_high),
                      ),
                      onSubmitted: (_) => _processInput(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _processInput,
                          icon: const Icon(Icons.send),
                          label: const Text('Застосувати'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _backgroundColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _textController.clear();
                              _message = '';
                            });
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text('Очистити'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_message.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _messageColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _messageColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: _messageColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                '💡 Підказка:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Введіть число для додавання\n'
                '• "Avada Kedavra" - скинути до 0\n'
                '• "Wingardium Leviosa" - подвоїти\n'
                '• "Lumos" - увімкнути світло\n'
                '• "Nox" - вимкнути світло',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Інкремент +1',
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
