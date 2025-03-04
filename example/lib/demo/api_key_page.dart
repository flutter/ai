import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class GeminiApiKeyPage extends StatefulWidget {
  const GeminiApiKeyPage({
    required this.title,
    required this.onApiKey,
    super.key,
  });

  final String title;
  final void Function(String apiKey) onApiKey;

  @override
  State<GeminiApiKeyPage> createState() => _GeminiApiKeyPageState();
}

class _GeminiApiKeyPageState extends State<GeminiApiKeyPage> {
  static final url = Uri.parse('https://aistudio.google.com/app/apikey');
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: Center(
      child: ValueListenableBuilder(
        valueListenable: _controller,
        builder:
            (context, value, child) => Column(
              children: [
                const Text(
                  'To run this sample, you need a Gemini API key.\n'
                  'Get your Gemini API Key from the following URL:',
                ),
                GestureDetector(
                  onTap: () => launchUrl(url, webOnlyWindowName: '_blank'),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      url.toString(),
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _copyUrl,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text('(or copy the URL above by tapping HERE)'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Paste your API key here:'),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Gemini API Key',
                      errorText:
                          _isValidApiKey()
                              ? null
                              : 'API key must be 39 characters',
                    ),
                    onSubmitted:
                        _isValidApiKey()
                            ? (apiKey) => widget.onApiKey(apiKey)
                            : null,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      _isValidApiKey()
                          ? () => widget.onApiKey(_controller.text)
                          : null,
                  child: const Text('Submit'),
                ),
              ],
            ),
      ),
    ),
  );

  bool _isValidApiKey() => _controller.text.length == 39;

  void _copyUrl() {
    Clipboard.setData(ClipboardData(text: url.toString()));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied URL to clipboard')));
  }
}
