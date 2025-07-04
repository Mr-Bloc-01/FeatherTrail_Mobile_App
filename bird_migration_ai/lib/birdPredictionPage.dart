import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class BirdPredictionPage extends StatefulWidget {
  const BirdPredictionPage({Key? key}) : super(key: key);

  @override
  State<BirdPredictionPage> createState() => _BirdPredictionPageState();
}

class _BirdPredictionPageState extends State<BirdPredictionPage> {
  File? _selectedImage;
  String? _prediction;
  double? _confidence;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to classify the bird using the backend
  Future<void> _classifyBird() async {
    if (_selectedImage == null) {
      _showAlertDialog('No Image Selected', 'Please select an image first.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://aarons-bird-migration-project.onrender.com/bird_detection');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);

      setState(() {
        _prediction = data['class'];
        _confidence = (data['confidence'] as num).toDouble();
        _isLoading = false;
      });

      _showAlertDialog(
        'Bird Classification Result',
        'Prediction: $_prediction\nConfidence: ${(_confidence! * 100).toStringAsFixed(2)}%',
      );
    } else {
      _isLoading = false;
      _showAlertDialog(
        'Error',
        'Error classifying bird: ${response.statusCode}',
      );
    }
  }

  // Function to display an AlertDialog
  Future<void> _showAlertDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFd4d4c8),
          title: Text(
            title,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black54),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    final cardColor = theme.cardColor;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        title: Text(
          'Species Identifier',
          style: theme.appBarTheme.titleTextStyle ?? TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              )
                  : Center(
                child: Text(
                  'No Image Selected',
                  style: TextStyle(color: textColor?.withOpacity(0.7), fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _pickImage,
              child: Text(
                'Pick Image from Gallery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
            ?  Center(
              child: SizedBox(
                width: 40,  // Fixed width
                height: 40, // Fixed height
                child: CircularProgressIndicator(
                  color: theme.colorScheme.secondary,
                  strokeWidth: 4.0, // Optional: controls the thickness of the spinner
                ),
              ),
            )
            : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _classifyBird,
              child: Text(
                'Classify Bird',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSecondary),
              ),
            ),
            const SizedBox(height: 20),
            if (_prediction != null && _confidence != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Text(
                  'Prediction: $_prediction\nConfidence: ${(_confidence! * 100).toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
