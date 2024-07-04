import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:web/models/parameters.dart';
import 'package:web/models/salary.dart';

class MainBloc {
  final nameControllerSubject = BehaviorSubject<String>.seeded('');
  final regionControllerSubject = BehaviorSubject<String>.seeded('');
  final salaryControllerSubject = BehaviorSubject<String>.seeded('');

  // Сюда записываем текст поиска (при новом значении)
  final searchTextSubjects = BehaviorSubject<String>.seeded('');
  // Храним текущее состояние результатов поиска
  final BehaviorSubject<ListWidgetState> stateSubject =
      BehaviorSubject.seeded(ListWidgetState.nothing);
  final BehaviorSubject<PageStateNumber> pageSubject =
      BehaviorSubject.seeded(PageStateNumber.first);

  // Храним здесь то, что получили от сервера(список со словарями)
  final searchResultSubject = BehaviorSubject<List>();

  StreamSubscription? textSubscription;

  StreamSubscription? searchSubscriprion;
  StreamSubscription? filtresSubscription;

  Stream<ListWidgetState> observeListWidgetState() => stateSubject;
  Stream<PageStateNumber> observePageState() => pageSubject;
  Stream observeSearchResults() => searchResultSubject;

  MainBloc() {
    filtresSubscription = Rx.combineLatest4(
        searchTextSubjects.debounceTime(Duration(milliseconds: 1000)),
        nameControllerSubject.debounceTime(Duration(milliseconds: 800)),
        regionControllerSubject.debounceTime(Duration(milliseconds: 800)),
        salaryControllerSubject.debounceTime(Duration(milliseconds: 800)),
        (searchText, name, region, salary) => FiltersInfo(
            searchText: searchText,
            name: name,
            region: region,
            salary: salary)).listen((value) {
      if (value.searchText != "") {
        searchForResultWithFilters(
            value.searchText, value.region, value.salary, value.name);
      }
    });
  }
  void searchForResultWithFilters(final String text, final String region,
      final String salary, final String name) {
    if (text != '') {
      stateSubject.add(ListWidgetState.loading);
      searchSubscriprion?.cancel();
      searchSubscriprion =
          searchWithFilters(text, region, salary, name).asStream().listen(
        (searchResult) {
          searchResultSubject.add(searchResult.toList());
          print("Good");
          stateSubject.add(ListWidgetState.list);
        },
        onError: (error, stackTrace) {
          print("SearchError");
          print(error);
          stateSubject.add(ListWidgetState.error);
        },
      );
    }
    // textSubscription = searchTextSubjects.distinct().listen((value) {
    //   //Здесь функция для запроса
    //   searchForResult(value);
    // });
  }

  //Здесь мы получаем текст поиска
  void updateText(final String? text) {
    if (text != null) {
      searchTextSubjects.add(text);
    }
  }

  Future searchWithFilters(final String text, final String region,
      final String salary, final String name) async {
    print("NAME: $name");
    var headers = {'Content-Type': 'application/json'};
    var data =
        json.encode({"text": text, "name": "$name", "area": "1", "salary": ""});
    var dio = Dio();

    var response = await dio.request(
      'http://127.0.0.1:5000/api/data',
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
    // print(found);
    return found;
  }

  // void searchForResult(final String text) {
  //   if (text != '') {
  //     stateSubject.add(ListWidgetState.loading);

  //     searchSubscriprion = search(text).asStream().listen(
  //       (searchResult) {
  //         searchResultSubject.add(searchResult.toList());
  //         print("Good");
  //         stateSubject.add(ListWidgetState.list);
  //       },
  //       onError: (error, stackTrace) {
  //         print("Error");
  //         print(error);
  //         stateSubject.add(ListWidgetState.error);
  //       },
  //     );
  //   }
  // }

  // Future search(final String searchText) async {
  //   print('request');
  //   var headers = {'Content-Type': 'application/json'};
  //   var data = json.encode({"text": "$searchText"});
  //   var dio = Dio();
  //   var response = await dio.request(
  //     'http://127.0.0.1:5000/text/',
  //     options: Options(
  //       method: 'POST',
  //       headers: headers,
  //     ),
  //     data: data,
  //   );

  //   final List<dynamic> parameters = response.data
  //       .map((rawParameters) => Parameters.fromJson(rawParameters))
  //       .toList();

  //   final List<dynamic> found = parameters.map((parameter) {
  //     return ParametersInfo.fromParameters(parameter);
  //   }).toList();

  //   return found;
  // }

  void dispose() {
    searchTextSubjects.close();
  }
}

class FiltersInfo {
  final String searchText;
  final String name;
  final String region;
  final String salary;

  FiltersInfo(
      {required this.searchText,
      required this.name,
      required this.region,
      required this.salary});

  @override
  String toString() =>
      'FiltersInfo(searchText: $searchText,: $name, region: $region, salary: $salary)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FiltersInfo &&
          runtimeType == other.runtimeType &&
          searchText == other.searchText &&
          name == other.name &&
          region == other.region &&
          salary == other.salary;

  @override
  int get hashCode =>
      searchText.hashCode ^ name.hashCode ^ region.hashCode ^ salary.hashCode;
}

enum ListWidgetState {
  list,
  error,
  loading,
  nothing,
}

enum PageStateNumber {
  first,
  second,
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
  String toString() {
    return 'ParametersInfo{id: $id, name: $name, salary: $salary, area: $area';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParametersInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          area == other.area &&
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
