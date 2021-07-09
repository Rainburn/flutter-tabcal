import 'dart:collection';
import 'dart:math';
import 'job.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Table Calendar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<dynamic> _selectedEvents = [];
  Map<String, List<Job>> _events = {};

  // final events = LinkedHashMap(
  //   equals: isSameDay,
  //   hashCode: getHashCode,
  // ).addAll(eventSource);

  @override
  void initState(){
    super.initState();

    // Populate Events
    Job job1 = new Job(day: DateTime(2021, 6, 10), jobDesc: "Slay Alatreon");
    Job job2 = new Job(day: DateTime(2021, 6, 10), jobDesc: "Slay Fatalis");
    Job job3 = new Job(day: DateTime(2021, 6, 9), jobDesc: "Slay Safi'jiiva");

    // _selectedEvents.add(job1);
    // _selectedEvents.add(job2);
    // _selectedEvents.add(job3);

    populateEvents(job1);
    populateEvents(job2);
    populateEvents(job3);

    
    _selectedEvents = _getEventsByDay(_selectedDay);
    debugPrint("Selected Events : ${_selectedEvents.toString()}");
  }

  void populateEvents(Job job) {
    String dateKey = formatDateAsKey(job.day);
    List<Job>? list = _events[dateKey];

    if (list == null) {
      list = [job];
      _events[dateKey] = list;
    }

    else {
      _events[dateKey]!.add(job);
    }


  }

  void _addTask() {

    // For Now, add Random Event
    int year = 2021;
    int month = 6;
    Random rnd = new Random();
    int min = 1;
    int max = 30;
    int date = min + rnd.nextInt(max - min);

    DateTime dt = DateTime(year, month, date);
    String dateKey = formatDateAsKey(dt);

    Job randomJob = new Job(day : dt, jobDesc:  "Slay ???");

    setState(() {
      populateEvents(randomJob);
    });

  }

  String formatDateAsKey(DateTime day) {
    DateFormat formatter = DateFormat('MMM-dd-yyyy');
    String dateKey = formatter.format(day);

    return dateKey;
  }

  List<Job> _getEventsByDay(DateTime day) {

    String dateKey = formatDateAsKey(day);
    List<Job>? fetchedList = _events[dateKey];
    List<Job> list = [];

    if (fetchedList == null) {
      return list;
    }

    return fetchedList;
    
  }

  Widget _buildListForEvents() {

    debugPrint("Events : ${_events.toString()}");

    if (_selectedEvents.length == 0) {
      return SizedBox.shrink();
    }
    
    return ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_selectedEvents[index].jobDesc),
          );
        }
    );
    
    
  }


  Widget _buildCalender() {

    return Container(
      child: Column(
        children: [

          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: _addTask,
                  child: Text("Add"),
              ),
            ],
          ),

          TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2050, 31, 12),
              eventLoader: (day) {
                return _getEventsByDay(day);
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onFormatChanged: (format) {
                setState(() {
                  debugPrint("Format Changed");
                  debugPrint("");
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {

                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;

                    _selectedEvents = _getEventsByDay(_selectedDay);
                  });

                  debugPrint("Selected Day (Var): ${_selectedDay.toString()}");
                  debugPrint("Focused Day (Var): ${_focusedDay.toString()}");
                  debugPrint("");
                  debugPrint("Selected Day (Func): ${selectedDay.toString()}");
                  debugPrint("Focused Day (Func): ${focusedDay.toString()}");
                  debugPrint("");

                }
              },

              onPageChanged: (focusedDay) {
                debugPrint("Page Changed, focusedDay change to : ${focusedDay.toString()}");
                _focusedDay = focusedDay;
              },


          ),


          // ListView for Events
          Expanded(child: _buildListForEvents()),
          // _buildListForEvents(),

        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: _buildCalender(),

    );
  }
}
