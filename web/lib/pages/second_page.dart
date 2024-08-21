import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/bloc/main_bloc.dart';
import 'package:web/bloc/second_page_bloc.dart';
import 'package:web/resources/app_colors.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late SecondPageBloc secondBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secondBloc = SecondPageBloc();
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc mainBloc = Provider.of<MainBloc>(context, listen: false);

    return Provider.value(
      value: secondBloc,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => mainBloc.pageSubject.add(PageStateNumber.first),
                  child: Container(
                    margin: EdgeInsets.only(top: 20, left: 50),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: AppColors.color800,
                        borderRadius: BorderRadius.circular(25)),
                    child: Icon(
                      Icons.reply,
                      color: AppColors.color200,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                secondBloc.getAllData(true);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 20, right: 50),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      alignment: Alignment.center,
                      height: 60,
                      width: 100,
                      decoration: BoxDecoration(
                          color: AppColors.color800,
                          borderRadius: BorderRadius.circular(25)),
                      child: Icon(
                        Icons.replay,
                        color: AppColors.color200,
                        size: 25,
                      ),
                      // Text(
                      //   "Click to update data",
                      //   style: TextStyle(
                      //       color: AppColors.color200,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w100),
                      // ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListContent()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ListContent extends StatelessWidget {
  const ListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final SecondPageBloc secondPageBloc =
        Provider.of<SecondPageBloc>(context, listen: false);
    return StreamBuilder<ListWidgetStateSecond>(
        stream: secondPageBloc.observeListWidgetState(),
        builder: (context, snapshot) {
          final ListWidgetStateSecond state =
              (snapshot.data ?? ListWidgetStateSecond.nothing);
          switch (state) {
            case ListWidgetStateSecond.list:
              return Expanded(child: ListWidget());
            case ListWidgetStateSecond.nothing:
              return Container(
                  // color: AppColors.color200,
                  // height: 20,
                  // child: Text('Не везет мне в смерти повезет в любви'),
                  );
            case ListWidgetStateSecond.error:
              //TODO Сделать кнопку попробовать снова
              return Center(
                  child: Text(
                "Something wrong",
                style: TextStyle(
                    color: AppColors.color300,
                    fontSize: 80,
                    fontWeight: FontWeight.w900),
              ));
            case ListWidgetStateSecond.loading:
              return CircularProgressIndicator(
                color: AppColors.color500,
              );
          }
        });
  }
}

class ListWidget extends StatelessWidget {
  const ListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SecondPageBloc secondPageBloc =
        Provider.of<SecondPageBloc>(context, listen: false);

    //Когда ничего не найдено добавить строчку
    return StreamBuilder(
        stream: secondPageBloc.observeRequestResults(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final content = snapshot.data[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ItemWidget(content: content),
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

  final content;
  final double title = 20;
  final double textFontSize = 19;

  @override
  Widget build(BuildContext context) {
    final salaryFrom =
        content.salary.from == null ? "___" : "${content.salary.from}";
    final salaryTo =
        content.salary.to == null ? "___ " : "${content.salary.to}";
    final region = content.area.id == null ? " " : "${content.area.name}";

    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: AppColors.color500, borderRadius: BorderRadius.circular(20)),
      height: 120,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.name,
                style: TextStyle(color: AppColors.color100, fontSize: title),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              TextWidget(
                text: 'Region: $region',
                textFontSize: textFontSize,
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      TextWidget(
                        text: "Salary",
                        textFontSize: textFontSize,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: "from: $salaryFrom",
                        textFontSize: textFontSize,
                      ),
                      TextWidget(
                          text: "to: $salaryTo", textFontSize: textFontSize)
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
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
