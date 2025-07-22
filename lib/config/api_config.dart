class ApiConfig {
  // Replace these URLs with your actual .NET backend endpoints
  
  // For production API
  static const String baseUrl = 'https://kamoro-teams-api-dev.azurewebsites.net/api';
  
  // For development (local .NET API) - using 10.0.2.2 for Android emulator
  // static const String baseUrl = 'http://10.0.2.2:7000/api';
  
  // For development (local .NET API) - alternative localhost
  // static const String baseUrl = 'https://localhost:7000/api';
  
  // API Endpoints
  static const String employeesEndpoint = '/employees';
  static const String healthEndpoint = '/health';
  
  // Employee endpoints
  static String employeeByIdEndpoint(String id) => '/employees/$id';
  static String employeeByUsernameEndpoint(String username) => '/employees/by-username/$username';
  static String searchEmployeesEndpoint(String query) => '/employees/search?q=$query';
  
  // Asset endpoints
  static const String assetsEndpoint = '/assets';
  static String assetByIdEndpoint(String id) => '/assets/$id';
  static const String assetTypesEndpoint = '/assets/types';
  static const String assetCompaniesEndpoint = '/assets/companies';
  
  // Asset Assignment endpoints
  static const String assetAssignmentsEndpoint = '/asset-assignment';
  static String assetAssignmentByIdEndpoint(String id) => '/asset-assignment/$id';
  static const String assetAssignmentTypesEndpoint = '/asset-assignment/types';
  
  // Employee Assignment endpoints
  static const String employeeAssignmentsEndpoint = '/employee-assignment';
  static String employeeAssignmentByIdEndpoint(String id) => '/employee-assignment/$id';
  
  // Employee Employment endpoints
  static const String employeeEmploymentEndpoint = '/employee-employment';
  static String employeeEmploymentByIdEndpoint(String id) => '/employee-employment/$id';
  static String employeeDocumentsEndpoint(String fileName) => '/employee-employment/documents/$fileName';
  
  // Emergency Contacts endpoints
  static const String emergencyContactsEndpoint = '/emergency-contacts';
  static String emergencyContactByIdEndpoint(String id) => '/emergency-contacts/$id';
  static const String emergencyContactRelationshipsEndpoint = '/emergency-contacts/relationship';
  
  // Access endpoints (for role/permissions management)
  static const String accessEndpoint = '/access';
  static String accessByRoleAndEmployeeEndpoint(String roleId, String employeeId) => '/access/$roleId/$employeeId';
  
  // Holidays endpoints
  static const String holidaysEndpoint = '/holidays';
  static String holidayByIdEndpoint(String id) => '/holidays/$id';
  static String holidayCardEndpoint(String fileName) => '/holidays/cards/$fileName';
  static String holidaySendEmailEndpoint(String id) => '/holidays/$id/send-email';
  
  // Lookup endpoints
  static const String lookupEndpoint = '/lookup';
  static const String lookupCategoriesEndpoint = '/lookup-categories';
  static const String lookupsEndpoint = '/lookups';
  
  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 10);
  
  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'KMI-Profile-Mobile/1.0',
  };
  
  // Add authentication headers if needed
  static Map<String, String> getAuthHeaders(String? token) => {
    ...defaultHeaders,
    if (token != null) 'Authorization': 'Bearer $token',
  };
}

// Example of what your .NET API controller might look like:
/*
[ApiController]
[Route("api/[controller]")]
public class EmployeesController : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<List<Employee>>> GetEmployees()
    {
        // Return list of employees
    }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<Employee>> GetEmployee(string id)
    {
        // Return specific employee by ID
    }
    
    [HttpGet("by-username/{username}")]
    public async Task<ActionResult<Employee>> GetEmployeeByUsername(string username)
    {
        // Return employee by username
    }
    
    [HttpGet("search")]
    public async Task<ActionResult<List<Employee>>> SearchEmployees(string q)
    {
        // Search employees by query
    }
    
    [HttpPut("{id}")]
    public async Task<ActionResult<Employee>> UpdateEmployee(string id, Employee employee)
    {
        // Update employee
    }
}

[ApiController]
[Route("api/[controller]")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        return Ok(new { status = "healthy", timestamp = DateTime.UtcNow });
    }
}
*/
