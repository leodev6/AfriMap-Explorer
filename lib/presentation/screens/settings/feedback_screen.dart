import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _controller = TextEditingController();
  String _selectedType = 'Suggestion';
  bool _submitted = false;

  final _types = ['Suggestion', 'Bug', 'Question', 'Autre'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildThankYou();

    return Scaffold(
      appBar: AppBar(title: const Text('Signaler un probleme')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),

            // Type selector
            const Text('Type de message',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _types.map((type) {
                final selected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: selected,
                  selectedColor: AppColors.primary.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: selected ? AppColors.primary : Colors.grey[600],
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  onSelected: (_) => setState(() => _selectedType = type),
                );
              }).toList(),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 20),

            // Message field
            const Text('Votre message',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 6,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Decrivez votre probleme ou suggestion...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 20),

            // Submit button
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _controller.text.trim().isEmpty ? null : _submit,
                icon: const Icon(Icons.send),
                label: const Text('Envoyer', style: TextStyle(fontSize: 16)),
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 12),
            Text(
              'Votre message sera traite dans les meilleurs delais.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.feedback_outlined, size: 48, color: AppColors.primary),
          SizedBox(height: 12),
          Text('Votre avis compte !',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Aidez-nous a ameliorer l\'application',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  void _submit() {
    setState(() => _submitted = true);
  }

  Widget _buildThankYou() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: AppColors.success)
                  .animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              const Text('Merci !',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Votre message a bien ete recu.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Retour aux parametres'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
