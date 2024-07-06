import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web/models/area.dart';

import 'package:web/models/parameters.dart';
import 'package:web/models/salary.dart';

class MainBloc {
  final BehaviorSubject<PageStateNumber> pageSubject =
      BehaviorSubject.seeded(PageStateNumber.first);
  Stream<ListWidgetState> observeListWidgetState() => stateSubject;

  // final nameControllerSubject = BehaviorSubject<String>.seeded('');
  final nameControllerSubject = BehaviorSubject<String>.seeded('');

  final regionControllerSubject = BehaviorSubject<String>.seeded('');
  final salaryControllerSubject = BehaviorSubject<String>.seeded('');

  // Сюда записываем текст поиска (при новом значении)
  final searchTextSubjects = BehaviorSubject<String>.seeded('');
  // Храним текущее состояние результатов поиска
  final BehaviorSubject<ListWidgetState> stateSubject =
      BehaviorSubject.seeded(ListWidgetState.nothing);

  // Храним здесь то, что получили от сервера(список со словарями)
  final searchResultSubject = BehaviorSubject<List>();

  StreamSubscription? textSubscription;

  StreamSubscription? searchSubscriprion;
  StreamSubscription? filtresSubscription;

  Stream<PageStateNumber> observePageState() => pageSubject;
  Stream observeSearchResults() => searchResultSubject;

  MainBloc() {
    filtresSubscription = Rx.combineLatest4(
        searchTextSubjects.debounceTime(Duration(milliseconds: 500)),
        nameControllerSubject.distinct(),
        regionControllerSubject.distinct(),
        salaryControllerSubject.distinct(),
        (searchText, name, region, salary) => FiltersInfo(
            searchText: searchText,
            name: name,
            region: region,
            salary: salary)).listen((value) {
      if (value.searchText != "") {
        print("NAME: ${value.name}");
        print("REGION: ${value.region}");
        print("SALARY: ${value.salary}");

        searchForResultWithFilters(
            text: value.searchText,
            region: value.region,
            salary: value.salary,
            name: value.name);
      }
    });
  }
  void searchForResultWithFilters(
      {required String text,
      required String region,
      required String salary,
      required String name}) {
    if (text != '') {
      stateSubject.add(ListWidgetState.loading);
      searchSubscriprion?.cancel();
      searchSubscriprion = searchWithFilters(
              text: text, region: region, name: name, salary: salary)
          .asStream()
          .listen(
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

  Future searchWithFilters({
    required String text,
    required String region,
    required String salary,
    required String name,
  }) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({
      "text": text,
      "name": "$name",
      "area": "$region",
      'salary': "$salary"
    });
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
    return found;
  }

  void dispose() {
    searchTextSubjects.close();
  }
}

class FiltersInfo {
  final searchText;
  final name;
  final region;
  final salary;

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

enum CheckBoxes {
  salary,
  region,
  name,
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
