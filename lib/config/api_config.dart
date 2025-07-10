class ApiConfig {
  // Replace these URLs with your actual .NET backend endpoints
  
  // For development (local .NET API) - using 10.0.2.2 for Android emulator
  static const String baseUrl = 'http://10.0.2.2:7000/api';
  
  // For development (local .NET API) - alternative localhost
  // static const String baseUrl = 'https://localhost:7000/api';
  
  // For production
  // static const String baseUrl = 'https://your-production-api.com/api';
  
  // API Endpoints
  static const String employeesEndpoint = '/employees';
  static const String healthEndpoint = '/health';
  
  // Specific employee endpoints
  static String employeeByIdEndpoint(String id) => '/employees/$id';
  static String employeeByUsernameEndpoint(String username) => '/employees/by-username/$username';
  static String searchEmployeesEndpoint(String query) => '/employees/search?q=$query';
  
  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 10);
  
  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
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
