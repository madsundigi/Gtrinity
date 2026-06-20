class ApiConstants {
  // Points to the Laravel backend's guard API.
  // Local Docker backend (served at :8080, routes under /api/guard):
  //   Android emulator   -> http://10.0.2.2:8080/api/guard/
  //   iOS simulator      -> http://localhost:8080/api/guard/
  //   Physical device    -> http://<your-computer-LAN-IP>:8080/api/guard/
  static const String baseUrl = 'http://10.0.2.2:8080/api/guard/';
  static const String loginEndpoint = 'login';
  static const String logoutEndpoint = 'logout';
  static const String dashboardEndpoint = 'dashboard';
  static const String punchInEndpoint = 'attendance/punch-in';
  static const String punchOutEndpoint = 'attendance/punch-out';
  static const String dutiesEndpoint = 'duties';
  static String acceptDutyEndpoint(int id) => 'duties/$id/accept';
  static String rejectDutyEndpoint(int id) => 'duties/$id/reject';
  static const String incidentsEndpoint = 'incidents';
  static const String leavesEndpoint = 'leaves';
  static const String applyLeaveEndpoint = 'leaves/apply';
  static const String documentsEndpoint = 'documents';
  static const String uploadDocumentEndpoint = 'documents/upload';
}
