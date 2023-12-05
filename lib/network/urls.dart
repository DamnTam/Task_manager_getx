import 'package:task_manager_project/ui/widgets/task_itemCard.dart';

class Urls{
  static String baseUrl='https://task.teamrabbil.com/api/v1';
  static String registrationUrl='$baseUrl/registration';
  static String loginUrl='$baseUrl/login';
  static String setPasswordUrl='$baseUrl/RecoverResetPass';
  static String createTaskUrl= '$baseUrl/createTask';
  static String profileUpdateUrl= '$baseUrl/profileUpdate';
  static String newTaskUrl= '$baseUrl/listTaskByStatus/${TaskStatus.New.name}';
  static String inProgressTaskUrl= '$baseUrl/listTaskByStatus/${TaskStatus.Progress.name}';
  static String cancelTaskUrl= '$baseUrl/listTaskByStatus/${TaskStatus.Cancelled.name}';
  static String completeTaskUrl= '$baseUrl/listTaskByStatus/${TaskStatus.Complete.name}';
  static String taskStatusCountUrls= '$baseUrl/taskStatusCount';
  static String emailVerificationUrls(String email)=> '$baseUrl/RecoverVerifyEmail/$email';
  static String verifyOtpUrls(String email,String otp)=> '$baseUrl/RecoverVerifyOTP/$email/$otp';
  static String deleteTaskUrls(String id)=> '$baseUrl/deleteTask/$id';
  static String updateTaskStatusUrls(String id,String status)=> '$baseUrl/updateTaskStatus/$id/$status';
}