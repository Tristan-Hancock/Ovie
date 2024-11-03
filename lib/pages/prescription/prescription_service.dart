import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class PrescriptionService {
  static final TextRecognizer _textRecognizer = TextRecognizer();

  static Future<String> extractPrescriptionText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    // Collect all extracted text
    String extractedText = recognizedText.text;

    // Close the recognizer after use to release resources
    await _textRecognizer.close();

    return extractedText;
  }
}
