// import 'dart:io';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// class OCRService {
//   final TextRecognizer _textRecognizer = TextRecognizer();

//   Future<String> recognizeText(File image) async {
//     final inputImage = InputImage.fromFile(image);
//     final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    
//     String extractedText = recognizedText.text;
//     await _textRecognizer.close(); // Close the recognizer when done
    
//     return extractedText;
//   }
// }
