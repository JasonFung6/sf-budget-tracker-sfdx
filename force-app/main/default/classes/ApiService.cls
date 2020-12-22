@RestResource(urlMapping='/budgettracker/*')
global class ApiService {
    /*
     * @description : Returns response body containing a single expenditure record or
     *                a list, otherwise an error code and message
     * @example     : http://api.jasonfung.co.uk/budgettracker
     * @link        : https://app.swaggerhub.com/apis/JasonFung6/Expenditure
     * TODO         : Better `apiType` validation, and default should return 404
     */
    @HttpGet
    global static void get() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        ErrorResponse errors;
        ExpenditureServiceModel data = new ExpenditureServiceModel();

        switch on req.params.get('apiType'){
            when 'single' {
                ExpenditureService.getExpenditure(req, res);
            }
            when 'multi' {
                ExpendituresService.getExpenditures(req, res);
            }
        }
    }

    public class ErrorResponse {
        public String message;

        public errorResponse(string message) {
            this.message = message;
        }
    }
}