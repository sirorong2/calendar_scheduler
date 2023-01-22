import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/schedule_botton_sheet.dart';
import 'package:calendar_scheduler/component/shedule_card.dart';
import 'package:calendar_scheduler/component/today_Banner.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              onDaySelected: onDaySelected,
              selectedDay: selectedDay,
              focusedDay: focusedDay,
            ),
            SizedBox(
              height: 8.0,
            ),
            TodayBanner(
              selectedDay: selectedDay,
              scheduleCount: 4,
            ),
            SizedBox(
              height: 8.0,
            ),
            _ScheduleList(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_){
            return ScheduleBottomSheet();
          },
        );
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(
        Icons.add,
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print(selectedDay);
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 8.0,
            );
          },
          itemBuilder: (context, index) {
            return ScheduleCard(
              startTime: 12,
              endTime: 14,
              content: '프로그래밍 공부하기 $index',
              color: Colors.red,
            );
          },
        ),
      ),
    );
  }
}
