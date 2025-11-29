import 'package:flutter/foundation.dart';

base class ApiEndpoints {
  static const String socketUrl = _RemoteServer.socketUrl;

  static const String baseUrl = _RemoteServer.baseUrl;

  // ---------------------- AUTH -----------------------------
  static const String login = _Auth.login;
  static const String signup = _Auth.signup;
  static const String emailverify = _Auth.emailverify;
  static const String verifyCode = _Auth.verifyCode;
  static const String forgetPassword = _Auth.forgetPassword;
  static const String changePassword = _Auth.changePassword;
  static const String createNewPassword = _Auth.resetPassword;
  static const String refreshToken = _Auth.refreshToken;

  static const String logout = _Auth.logout;

  // ---------------------- USER -----------------------------
  /// ### get
  static String getuserbyId(String id) => _User.getuserbyId(id);
  /// ### patch
  static const String updateUser = _User.updateUser;
  /// ### patch
  static const String uploadProfileImage = _User.uploadProfileImage;
  //Get
  static const String staffList = _User.staffList;

  // ---------------------- jobs -----------------------------
  //get
  static const String jobList = _Jobs.jobList;
  static String getJobs(String id) => _Jobs.getJobs(id);
  //post
  static const String createJob = _Jobs.createJob;
  //patch
  static String updateJob(String id) => _Jobs.updateJob(id);
  //patch
  static String updateJobStatus(String id) => _Jobs.updateJobStatus(id);
  //patch
  static String updateJobAssignment(String id) => _Jobs.updateJobAssignment(id);
  //delete
  static String deleteJob(String id) => _Jobs.deleteJob(id);
  //get
  static String listJobApplications(String id) => _Jobs.listJobApplications(id);
  //get
  static const String listAssignedJobsStaffView =
      _Jobs.listAssignedJobsStaffView;
  //get
  static const String scaffoldOverviewManager = _Jobs.scaffoldOverviewManager;

  //---------------------------applications--------------------------
  static const String submitScaffold = _Application.application;
  static const String myScaffoldList = _Application.myScaffoldList;
}

class _RemoteServer {
  static const String socketUrl =
      'https://williamharri-backend-anlh.onrender.com'
      '';

  static const String baseUrl =
      'https://williamharri-backend-anlh.onrender.com/api'
      '';

  // static const String baseUrl =
  //     'http://10.10.5.89:8001/api'
  //     ;
}

class _LocalHostWifi {
  static const String socketUrl = 'http://10.10.5.46:8001';

  static const String baseUrl = 'http://10.10.5.46:8001/api';
}

class _Auth {
  @protected
  static const String _authRoute = '${ApiEndpoints.baseUrl}/auth';
  static const String login = '$_authRoute/login';
  static const String signup = '$_authRoute/register';
  static const String forgetPassword = '$_authRoute/forgot-password';
  static const String refreshToken = '$_authRoute/refresh-token';
  static const String emailverify = '$_authRoute/verify-email';
  static const String verifyCode = '$_authRoute/verify-reset-otp';
  static const String changePassword = '$_authRoute/change-password';
  static const String resetPassword = '$_authRoute/reset-password';
  static const String logout = '$_authRoute/logout';
}

//-------------------------- user -----------------------
class _User {
  static const String _userRoute = '${ApiEndpoints.baseUrl}/users';
  static String getuserbyId(String id) => '$_userRoute/me';
  static const String updateUser = '$_userRoute/me';
  static const String uploadProfileImage = '$_userRoute/me/avatar';
  static const String staffList = '$_userRoute/staff';
}

// ---------------------- Notification -----------------------------

// ---------------------- jobs -------------------------------------
class _Jobs {
  static const String _jobsRoute = '${ApiEndpoints.baseUrl}/jobs';
  static const String jobList = '$_jobsRoute/';
  static String getJobs(String id) => '$_jobsRoute/$id';
  static const String createJob = '$_jobsRoute/';
  static String updateJob(String id) => '$_jobsRoute/$id';
  static String updateJobStatus(String id) => '$_jobsRoute/$id/status';
  static String updateJobAssignment(String id) => '$_jobsRoute/$id/assignment';
  static String deleteJob(String id) => '$_jobsRoute/$id';
  static String listJobApplications(String id) =>
      '$_jobsRoute/$id/applications';
  static const String listAssignedJobsStaffView = '$_jobsRoute/assigned/me';
  static const String scaffoldOverviewManager =
      '$_jobsRoute/scaffolds/overview';
}

// ---------------------- applications -------------------------------------
class _Application {
  static const String _applicationRoute =
      '${ApiEndpoints.baseUrl}/applications';
  static const String application = '$_applicationRoute/';
  static const String myScaffoldList = '$_applicationRoute/mine';

}
