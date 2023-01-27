import 'package:todo_list_app/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_app/app/models/task_filter_enum.dart';
import 'package:todo_list_app/app/models/task_model.dart';
import 'package:todo_list_app/app/models/total_tasks_model.dart';
import 'package:todo_list_app/app/models/week_task_model.dart';
import 'package:todo_list_app/app/services/tasks/tasks_service.dart';

class HomeController extends DefaultChangeNotifier {
  final TasksService _tasksService;
  var filterSelected = TaskFilterEnum.today;
  TotalTasksModel? todayTotalTasks;
  TotalTasksModel? tomorrowTotalTasks;
  TotalTasksModel? weekTotalTasks;
  List<TaskModel> allTasks = [];
  List<TaskModel> filteredTasks = [];
  DateTime? initialDateOfWeek;
  DateTime? selectedDate;
  bool showFinishedTasks = false;

  HomeController({required TasksService tasksService})
      : _tasksService = tasksService;

  Future<void> loadTotalTasks() async {
    final allTasks = await Future.wait([
      _tasksService.getToday(),
      _tasksService.getTomorrow(),
      _tasksService.getWeek()
    ]);

    final todayTasks = allTasks[0] as List<TaskModel>;
    final tomorrowTasks = allTasks[1] as List<TaskModel>;
    final weekTasks = allTasks[2] as WeekTaskModel;

    todayTotalTasks = TotalTasksModel(
        totalTasks: todayTasks.length,
        totalTasksFinished: todayTasks.where((task) => task.finished).length);
    tomorrowTotalTasks = TotalTasksModel(
        totalTasks: tomorrowTasks.length,
        totalTasksFinished:
            tomorrowTasks.where((task) => task.finished).length);
    weekTotalTasks = TotalTasksModel(
        totalTasks: weekTasks.tasks.length,
        totalTasksFinished:
            weekTasks.tasks.where((task) => task.finished).length);

    initialDateOfWeek = weekTasks.startDate;
    notifyListeners();
  }

  Future<void> findTasks({required TaskFilterEnum filter}) async {
    showLoading();
    notifyListeners();
    List<TaskModel> tasks;
    filterSelected = filter;

    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _tasksService.getToday();
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTomorrow();
        break;
      case TaskFilterEnum.week:
        final weekTasks = await _tasksService.getWeek();
        initialDateOfWeek = weekTasks.startDate;
        tasks = weekTasks.tasks;
        break;
    }

    filteredTasks = tasks;
    allTasks = tasks;

    if (filter == TaskFilterEnum.week) {
      if (selectedDate != null) {
        filterByDay(selectedDate!);
      } else if (initialDateOfWeek != null) {
        filterByDay(initialDateOfWeek!);
      }
    } else {
      selectedDate = null;
    }

    if (!showFinishedTasks) {
      filteredTasks =
          filteredTasks.where((task) => task.finished == false).toList();
    }

    hideLoading();
    notifyListeners();
  }

  void filterByDay(DateTime date) {
    selectedDate = date;
    filteredTasks = allTasks.where((task) {
      return task.dateTime == date;
    }).toList();

    if (!showFinishedTasks) {
      filteredTasks =
          filteredTasks.where((task) => task.finished == false).toList();
    }
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await findTasks(filter: filterSelected);
    await loadTotalTasks();
    notifyListeners();
  }

  Future<void> chekOrUncheckTask(TaskModel task) async {
    showLoadingAndResetState();
    notifyListeners();
    final taskUpdate = task.copyWith(finished: !task.finished);
    await _tasksService.chekOrUncheckTask(taskUpdate);
    hideLoading();
    refreshPage();
  }

  Future<void> deleteTask(int id) async {
    showLoadingAndResetState();
    notifyListeners();
    await _tasksService.deleteTask(id);
    hideLoading();
    refreshPage();
  }

  void showOrHideFinishedTasks() {
    showFinishedTasks = !showFinishedTasks;
    refreshPage();
  }
}
