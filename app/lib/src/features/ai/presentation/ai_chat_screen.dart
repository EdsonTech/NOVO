import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/maju_colors.dart';
import 'ai_providers.dart';

class _Msg {
  const _Msg(this.text, {this.fromUser = false});
  final String text;
  final bool fromUser;
}

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _input = TextEditingController();
  final _messages = <_Msg>[
    const _Msg('Olá, Maria! Sou a MAJU IA, a sua assistente financeira. '
        'Posso responder a perguntas ou digitalizar um comprovante para lançar automaticamente. 💡'),
  ];
  bool _thinking = false;

  static const _suggestions = [
    'Posso comprar uma viatura?',
    'Quanto devo poupar?',
    'Como reduzir gastos?',
  ];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_Msg(text, fromUser: true));
      _input.clear();
      _thinking = true;
    });
    final answer = await ref.read(aiRepositoryProvider).ask(text);
    if (!mounted) return;
    setState(() {
      _messages.add(_Msg(answer));
      _thinking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MAJU IA')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                for (final m in _messages) _bubble(m),
                if (_thinking) _bubble(const _Msg('...')),
                const SizedBox(height: 8),
                _scanCard(),
              ],
            ),
          ),
          _suggestionBar(),
          _composer(),
        ],
      ),
    );
  }

  Widget _bubble(_Msg m) => Align(
        alignment: m.fromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color: m.fromUser ? MajuColors.blue700 : MajuColors.card,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(m.fromUser ? 18 : 5),
              bottomRight: Radius.circular(m.fromUser ? 5 : 18),
            ),
            boxShadow: m.fromUser ? null : const [BoxShadow(color: Color(0x0F102A4F), blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: Text(
            m.text,
            style: TextStyle(fontSize: 14, height: 1.45, color: m.fromUser ? Colors.white : MajuColors.ink),
          ),
        ),
      );

  Widget _scanCard() => GestureDetector(
        onTap: () => context.push(Routes.aiScan),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [MajuColors.blue700, MajuColors.blue500]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: const [
              Icon(Icons.document_scanner_outlined, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Digitalizar comprovante',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'Montserrat')),
                    Text('Lançamento automático + classificação',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      );

  Widget _suggestionBar() => SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          children: [
            for (final s in _suggestions)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(s, style: const TextStyle(fontSize: 12.5)),
                  backgroundColor: MajuColors.blue100,
                  side: BorderSide.none,
                  onPressed: () => _send(s),
                ),
              ),
          ],
        ),
      );

  Widget _composer() => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _send,
                  decoration: const InputDecoration(hintText: 'Escreva uma pergunta...'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: MajuColors.orange500),
                onPressed: () => _send(_input.text),
                icon: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ),
      );
}
