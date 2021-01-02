@RestResource(urlMapping='/budgettracker/*')
global class ApiService {
    public final static Set<String> ApiOption = new Set<String>{
        'single',
        'multi',
        'acc'
    };

    /*
     * @description : Returns response body containing either:
     *                a.) Single expenditure record
     *                b.) List of expenditure records
     *                c.) Account and related Bank information
     * @example     : http://api.jasonfung.co.uk/budgettracker
     * @link        : https://app.swaggerhub.com/apis/JasonFung6/Expenditure
     */
    @HttpGet
    global static void get() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        ErrorResponse errors;
        String apiType = req.params.get('apiType');

        if (apiOption.contains(apiType) && !String.isBlank(apiType)) {
            switch on apiType {
                when 'single' {
                    ExpenditureService.getExpenditure(req, res);
                }
                when 'multi' {
                    ExpendituresService.getExpenditures(req, res);
                }
                when 'acc' {
                    AccountService.getAccountDetails(req, res);
                }
            }
        } else {
            res.statusCode = 400;
            errors = new ErrorResponse('Bad Request');
            res.responseBody = Blob.valueOf(JSON.serializePretty(errors));

            return;
        }
    }

    public class ErrorResponse {
        public String message;

        public errorResponse(string message) {
            this.message = message;
        }
    }
}