import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web/models/parameters.dart';

class SecondPageBloc {
  final getDataSubject = BehaviorSubject<bool>.seeded(false);

  // Храним здесь то, что получили от сервера(список со словарями)
  final requestResultSubject = BehaviorSubject<List>();

  final BehaviorSubject<ListWidgetStateSecond> stateListSubject =
      BehaviorSubject.seeded(ListWidgetStateSecond.nothing);

  StreamSubscription? getDataSubscription;
  StreamSubscription? requestSubscription;

  Stream<ListWidgetStateSecond> observeListWidgetState() => stateListSubject;

//через это общаемся со страницей
  Stream observeRequestResults() => requestResultSubject;

  void getAllData(bool search) {
    if (true) {
      getDataSubject.add(search);
    }
  }

  SecondPageBloc() {
    getDataSubscription = getDataSubject.listen((value) {
      requestAndGetResults();
    });
  }
  void requestAndGetResults() {
    stateListSubject.add(ListWidgetStateSecond.loading);
    requestSubscription?.cancel();
    requestSubscription = requestToServer().asStream().listen(
      (result) {
        requestResultSubject.add(result.toList());
        print('Good');
        stateListSubject.add(ListWidgetStateSecond.list);
      },
      onError: (error, stackTrace) {
        print("SearchError");
        print(error);
        stateListSubject.add(ListWidgetStateSecond.error);
      },
    );
  }

  Future requestToServer() async {
    var headers = {'Content-Type': 'text/plain'};
    var data = '''true''';
    var dio = Dio();
    var response = await dio.request(
      'http://127.0.0.1:5000/check_true',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    final List<dynamic> parameters = response.data
        .map((rawParameters) => Parameters.fromJson(rawParameters))
        .toList();

    final List<dynamic> found = parameters.map((parameter) {
      return ParametersInfo.fromParameters(parameter);
    }).toList();
    return found;
  }

  @override
  void dispose() {
    requestSubscription?.cancel();
    getDataSubscription?.cancel();
    getDataSubject.close();
  }
}

class ParametersInfo {
  final String name;
  final int id;
  final salary;
  final area;

  ParametersInfo({
    required this.salary,
    required this.area,
    required this.name,
    required this.id,
  });

  factory ParametersInfo.fromParameters(final Parameters parameter) {
    return ParametersInfo(
      id: parameter.id,
      name: parameter.name,
      salary: parameter.salary,
      area: parameter.area,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParametersInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id &&
          salary == other.salary &&
          area == other.area;

  @override
  int get hashCode =>
      name.hashCode ^ id.hashCode ^ salary.hashCode ^ area.hashCode;
}

enum ListWidgetStateSecond {
  list,
  error,
  loading,
  nothing,
}
