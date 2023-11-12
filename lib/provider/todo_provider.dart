import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/task_model.dart';

class TodoProvider {
  static const String baseUrl = 'http://192.168.43.177:8080';
  static const String saveEndpoint = '/save';
  static const String deleteEndpoint = '/delete';
  static const String updateEndpoint = '/update';

  Future<List<TaskModel>> fetchData() async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: const {"Content-Type": "application/json"},
      );

      final parsedData = await json.decode(response.body);
      List todoData = List.from(parsedData['toDo']);

      return todoData.map((e) => TaskModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addData(Map<String, String> body) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl$saveEndpoint'),
        headers: const {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteData(Map<String, String> id) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl$deleteEndpoint'),
        headers: const {"Content-Type": "application/json"},
        body: jsonEncode(id),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateData(String id, Map<String, String> data) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl$updateEndpoint'),
        headers: const {"Content-Type": "application/json"},
        body: jsonEncode({"_id": id, "text": data["text"]}),
      );

      return response.body;
    } catch (e) {
      rethrow;
    }
  }
}
