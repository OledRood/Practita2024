import 'dart:async';
import 'dart:js_interop';
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:web/pages/second_page.dart';
import 'package:web/resources/regions_list.dart';

import '../resources/app_colors.dart';
import '../bloc/main_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MainBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(value: bloc, child: PageContent());
  }
}

class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    // bloc.updateText("flutter");

    return Scaffold(
        backgroundColor: AppColors.color900,
        body: StreamBuilder(
            stream: bloc.observePageState(),
            builder: (context, snapshot) {
              final PageStateNumber number =
                  snapshot.data ?? PageStateNumber.first;
              switch (number) {
                case PageStateNumber.first:
                  return FirstPage();
                case PageStateNumber.second:
                  return SecondPage();
              }
            }));
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final double heigthAppBar = 60;
  bool open = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color900,
      appBar: AppBar(
        // forceMaterialTransparency: true,
        toolbarHeight: open ? 255 : 80,
        backgroundColor: AppColors.colorAppBar,
        title: Column(
          children: [
            AppWidget(
                onTap: () {
                  setState(() {
                    open = !open;
                    print(open);
                  });
                },
                open: open,
                heigthAppBar: heigthAppBar),
            FiltersWidget(open: open),
          ],
        ),
      ),
      body: Column(
        children: [
          ListContent(),
        ],
      ),
    );
  }
}

class AppWidget extends StatelessWidget {
  const AppWidget(
      {super.key,
      required this.onTap,
      required this.heigthAppBar,
      required this.open});
  final VoidCallback onTap;
  final double heigthAppBar;
  final bool open;
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: heigthAppBar,
            width: 60,
            decoration: BoxDecoration(
                color: AppColors.color800,
                borderRadius: BorderRadius.circular(25)),
            child: Icon(
              open
                  ? Icons.circle_outlined
                  : Icons.arrow_drop_down_circle_outlined,
              color: AppColors.color200,
              size: 25,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SearchWidget(
            heigthAppBar: heigthAppBar,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            bloc.searchSubscriprion?.cancel();
            bloc.pageSubject.add(PageStateNumber.second);
            bloc.stateSubject.add(ListWidgetState.nothing);
          },
          child: Container(
            height: heigthAppBar,
            width: 60,
            decoration: BoxDecoration(
                color: AppColors.color800,
                borderRadius: BorderRadius.circular(25)),
            child: Icon(
              Icons.plagiarism,
              color: AppColors.color200,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }
}

class FiltersWidget extends StatefulWidget {
  final bool open;
  const FiltersWidget({
    super.key,
    required this.open,
  });

  @override
  State<FiltersWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {
  final fromSalaryController = TextEditingController();
  final toSalaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    if (widget.open) {
      return Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: AppColors.color800,
                borderRadius: BorderRadius.circular(30)),
            height: 150,
            margin: const EdgeInsets.only(left: 70, right: 70),
            child: Stack(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NameItemWidget(
                          text: "Name",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            RegionItemWidget(),
                            SizedBox(
                              width: 80,
                            ),
                            SalaryItemWidget()
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 10),
                //     child: Text('if closed – the filters will be reset',
                //         style: TextStyle(
                //             fontSize: 10,
                //             color: AppColors.color400,
                //             fontWeight: FontWeight.w900)),
                //   ),
                // )
              ],
            ),
          ),
        ],
      );
    } else {
      bloc.nameControllerSubject.add('');
      bloc.regionControllerSubject.add('');
      bloc.salaryControllerSubject.add('');
      return const SizedBox.shrink();
    }
  }
}

class SalaryItemWidget extends StatefulWidget {
  const SalaryItemWidget({
    super.key,
  });

  @override
  State<SalaryItemWidget> createState() => _SalaryItemWidgetState();
}

class _SalaryItemWidgetState extends State<SalaryItemWidget> {
  var salaryCheck = false;
  var fromSalaryController = TextEditingController();
  final toSalaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return Container(
      // width: 200,
      height: 45,
      child: Row(
        children: [
          Text(
            'Salary:',
            style: TextStyle(fontSize: 16, color: AppColors.color200),
          ),
          const SizedBox(width: 13),
          //From
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 16, bottom: 13),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.color600),
              borderRadius: BorderRadius.circular(20),
            ),
            // height: 37,
            width: 100,
            child: Center(
              child: TextField(
                style: TextStyle(fontSize: 15, color: AppColors.color100),
                controller: fromSalaryController,
                onChanged: (value) {
                  setState(() {
                    salaryCheck = false;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    salaryCheck = true;
                    bloc.salaryControllerSubject.add(
                        "${fromSalaryController.text},${toSalaryController.text}");
                    if (value == '') salaryCheck = false;
                  });
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(7),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'From',
                    hintStyle: TextStyle(color: AppColors.color200)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            color: AppColors.color600,
            height: 2,
            width: 8,
          ),
          //To
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 16, bottom: 13),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.color600),
              borderRadius: BorderRadius.circular(20),
            ),
            // height: 37,
            width: 100,
            child: Center(
              child: TextField(
                style: TextStyle(fontSize: 15, color: AppColors.color100),
                controller: toSalaryController,
                onSubmitted: (value) {
                  setState(() {
                    salaryCheck = true;
                    bloc.nameControllerSubject.add(
                        "${fromSalaryController.text},${toSalaryController.text}");
                    if (value == '') salaryCheck = false;
                  });
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(7),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'To',
                    hintStyle: TextStyle(color: AppColors.color200)),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                salaryCheck = !salaryCheck;
                salaryCheck
                    ? bloc.salaryControllerSubject.add(
                        "${fromSalaryController.text},${toSalaryController.text}")
                    : bloc.salaryControllerSubject.add('');
              });
            },
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              height: 25,
              width: 25,
              child: Icon(salaryCheck ? Icons.check : Icons.close, size: 17),
            ),
          )
        ],
      ),
    );
  }
}

class RegionItemWidget extends StatefulWidget {
  const RegionItemWidget({super.key});

  @override
  State<RegionItemWidget> createState() => _RegionItemWidgetState();
}

class _RegionItemWidgetState extends State<RegionItemWidget> {
  bool regionChek = false;
  String changedRegion = 'Москва';

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return Row(
      children: [
        Text(
          "Region:",
          style: TextStyle(fontSize: 16, color: AppColors.color200),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 0.5, color: AppColors.color600)),
          // width: 270,
          child: Row(
            children: [
              Container(
                width: 100,
                height: 30,
                child: Center(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: changedRegion,
                    dropdownColor: AppColors.color800,
                    style: TextStyle(color: AppColors.color100),
                    items: RegionsList.regions.keys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        changedRegion = newValue!;
                        regionChek = true;
                        bloc.regionControllerSubject
                            .add(RegionsList.regions[changedRegion]!);
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    icon: null,
                    underline: Container(
                      color: AppColors.color900,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    regionChek = !regionChek;
                    regionChek
                        ? bloc.regionControllerSubject
                            .add(RegionsList.regions[changedRegion]!)
                        : bloc.regionControllerSubject.add('');
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  height: 25,
                  width: 25,
                  child: Icon(regionChek ? Icons.check : Icons.close, size: 17),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class NameItemWidget extends StatefulWidget {
  final String text;

  const NameItemWidget({
    super.key,
    required this.text,
  });

  @override
  State<NameItemWidget> createState() => _NameItemWidgetState();
}

class _NameItemWidgetState extends State<NameItemWidget> {
  bool check = false;
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return Row(
      children: [
        Text(
          "${widget.text}:",
          style: TextStyle(fontSize: 16, color: AppColors.color200),
        ),
        SizedBox(
          width: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 19, vertical: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 0.5, color: AppColors.color600)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 14),
                alignment: Alignment.center,
                width: 700,
                height: 30,

                // color: AppColors.color700,
                child: TextField(
                  style: TextStyle(fontSize: 16, color: AppColors.color100),
                  controller: nameController,
                  onSubmitted: (value) {
                    setState(() {
                      check = true;
                      bloc.nameControllerSubject.add(nameController.text);
                      bloc.updateText("");
                      if (value == '') check = false;
                    });
                  },
                  // inputFormatters: [LengthLimitingTextInputFormatter(25)],
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    check = !check;
                    check
                        ? bloc.nameControllerSubject.add(nameController.text)
                        : bloc.nameControllerSubject.add('');
                    bloc.updateText('');
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  height: 25,
                  width: 25,
                  child: Icon(check ? Icons.check : Icons.close, size: 17),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.heigthAppBar,
  });

  final double heigthAppBar;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        alignment: Alignment.center,
        height: widget.heigthAppBar,
        decoration: BoxDecoration(
            color: AppColors.color800, borderRadius: BorderRadius.circular(30)),
        child: TextField(
          autofocus: true,
          onSubmitted: (value) {
            bloc.updateText(value);
          },
          controller: controller,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
              suffix: GestureDetector(
            onTap: () {
              print("TAP");
              bloc.updateText(controller.text);
            },
            child: Icon(
              color: AppColors.color200,
              Icons.search,
              size: 25,
            ),
          )),
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ListContent extends StatelessWidget {
  const ListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<ListWidgetState>(
        stream: bloc.observeListWidgetState(),
        builder: (context, snapshot) {
          final ListWidgetState state =
              snapshot.data ?? ListWidgetState.nothing;
          switch (state) {
            case ListWidgetState.list:
              return Expanded(child: ListWidget(bloc: bloc));
            case ListWidgetState.nothing:
              return Container();
            case ListWidgetState.nothingFound:
              return Container(
                child: Center(
                  child: Text(
                    'Nothing found',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
                // Доделать введите запрос или ничего не найдено (подразделение)
              );
            case ListWidgetState.error:
              //TODO Сделать кнопку попробовать снова
              return Center(
                  child: Text(
                "Something wrong",
                style: TextStyle(
                    color: AppColors.color300,
                    fontSize: 80,
                    fontWeight: FontWeight.w900),
              ));
            case ListWidgetState.loading:
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.color500,
                ),
              );
          }
        });
  }
}

class ListWidget extends StatelessWidget {
  final MainBloc bloc;
  const ListWidget({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    //Когда ничего не найдено добавить строчку
    return StreamBuilder<List<ParametersInfo>>(
        stream: bloc.observeSearchResults(),
        builder: (context, resumes) {
          if (!resumes.hasData || resumes.data == null) {
            return const SizedBox.shrink();
          }

          return StreamBuilder<List>(
              stream: bloc.regionListSubject,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox.shrink();
                }
                final List regionList = snapshot.data!;
                print(regionList);

                return ListView.builder(
                  itemCount: regionList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // final List resumeByRegion = resumes.data!.map((resume) {
                    //   if (resume.area.name == regionList[index]) {
                    //     return resume;
                    //   }
                    // }).toList();
                    final resumeByRegion = [1, 2, 3, 4, 5];
                    return ListView.builder(
                      itemCount: resumeByRegion.length,
                      itemBuilder: (build, index) {
                        return Text("$index");
                      },
                    );
                  },
                );
              });

//Переделать Переделать

          return ListView.separated(
            itemCount: (resumes.data!.length + 1),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return SizedBox.shrink();
              }
              final content = resumes.data![index - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: ItemWidget(content: content)),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 20,
              );
            },
          );
        });
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.content,
  });

  final ParametersInfo content;
  final double title = 20;
  final double textFontSize = 19;
  final int maxLength = 80;

  @override
  Widget build(BuildContext context) {
    late String name;
    final salaryFrom = _convertSalary(content.salary.from);
    final salaryTo = _convertSalary(content.salary.to);
    final region = _convertRegion(content.area.name);
    final salaryUp = _convertSalryCurrence(content.salary.currency);
    if (content.name == null) {
      name = '';
    } else if (content.name.length > maxLength) {
      name = content.name.substring(0, maxLength) + "...";
    } else {
      name = content.name;
    }
    return GestureDetector(
        onTap: () => _launchURL(content.alternate_url.toString()),
        child: Container(
          width: 800,
          // height: 120,
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.color500,
              borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: TextStyle(
                        color: AppColors.color100,
                        fontSize: title,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Region: $region',
                      textFontSize: textFontSize,
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                SizedBox(
                  width: 250,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          TextWidget(
                              text: "Salary ($salaryUp)",
                              textFontSize: textFontSize)
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(text: "from:", textFontSize: textFontSize),
                          TextWidget(text: "to:", textFontSize: textFontSize),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextWidget(
                              text: salaryFrom, textFontSize: textFontSize),
                          TextWidget(
                              text: salaryTo, textFontSize: textFontSize),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ));
  }

  void _launchURL(String urlString) {
    html.window.open(urlString, '_blank');
  }

  String _convertSalary(salaryPart) {
    var isChislo = salaryPart == null ? false : true;
    var rightString = salaryPart == null ? "____" : "${salaryPart}";
    if (isChislo) {
      var index = rightString.length;
      var position = 3;
      while (true) {
        index -= position;
        if (index < 2) break;
        rightString =
            "${rightString.substring(0, index)} ${rightString.substring(index)}";
      }
    }

    return rightString;
  }

  String _convertSalryCurrence(currency) {
    return currency == "non" ? "RUR".toLowerCase() : '$currency'.toLowerCase();
  }

  String _convertRegion(region) {
    return region == null ? " " : "${region}";
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.text, required this.textFontSize});

  final text;
  final textFontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: AppColors.color200, fontSize: textFontSize),
    );
  }
}
