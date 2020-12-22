public without sharing class ExpendituresService {
    public final static Set<String> OrderByOption = new Set<String>{
        'ascending',
        'descending'
    };
    public final static Set<String> PeriodOption = new Set<String>{
        'daily',
        'monthly',
        'yearly'
    };
    public static ErrorResponse errors;
    public static String category;
    public static String period;
    public static String orderBy = 'ascending';
    public static Integer limiter = 10;

    /*
     * @method  : getExpenditures
     * @desc    : Return a list of expenditure items with the following optional
     *            filters applied, `category`, `period`, `orderBy`, `limit`
     * @link    : https://app.swaggerhub.com/apis/JasonFung6/Expenditure/1.0.0-oas3#/default/getListByFilters
     */
    public static void getExpenditures(RestRequest req, RestResponse res) {
        List<ExpendituresServiceModel> data = new List<ExpendituresServiceModel>();

        String accountId = req.params.get('accId');

        if (accountId == null || accountId == '') {
            res.statusCode = 400;
            errors = new ErrorResponse('Bad Request');
            res.responseBody = Blob.valueOf(JSON.serializePretty(errors));

            return;
        }

        // Make sure no invalid options from query params
        // are processed before we query the database.
        if (setOptionalQueryParams(req, res)) {
            res.addHeader('Content-Type', 'application/json; charset=utf-8');

            try {
                List<Expenditure__c> exps = QueryUtils.getExpendituresWithFilters(
                    accountId,
                    category,
                    period,
                    orderBy,
                    limiter
                );

                if (exps.size() > 0) {
                    for (Expenditure__c exp : exps) {
                        ExpendituresServiceModel esm = new ExpendituresServiceModel();

                        esm.id = exp.Id;
                        esm.amount = exp.Amount__c;
                        esm.createdDate = exp.CreatedDate.getTime();
                        esm.category = exp.Category__c;

                        data.add(esm);
                    }

                    res.statusCode = 200;
                    res.responseBody = Blob.valueOf(JSON.serializePretty(data));
                } else {
                    res.statusCode = 404;
                    errors = new ErrorResponse('Expenditure item(s) not found');
                    res.responseBody = Blob.valueOf(
                        JSON.serializePretty(errors)
                    );

                    return;
                }
            } catch (Exception e) {
                res.statusCode = 404;
                errors = new ErrorResponse('Expenditure item(s) not found');
                res.responseBody = Blob.valueOf(JSON.serializePretty(errors));

                return;
            }
        }
    }

    /**
     * @method  setOptionalQueryParams()
     * @desc    set query params if there's available data
     *          and the data matches the pre-defined options before
     *          assigning them to the class variables
     * @returns Boolean
     */
    private static Boolean setOptionalQueryParams(
        RestRequest req,
        RestResponse res
    ) {
        if (
            req.params.containsKey('category') &&
            req.params.get('category') != null &&
            req.params.get('category') != ''
        ) {
            category = req.params.get('category');
        }

        if (
            req.params.containsKey('period') &&
            req.params.get('period') != null &&
            req.params.get('period') != ''
        ) {
            String periodParam = req.params.get('period');

            // Ensure period value is a valid option
            if (PeriodOption.contains(periodParam)) {
                period = periodParam;
            } else {
                res.statusCode = 400;
                errors = new ErrorResponse('Bad Request, invalid option');
                res.responseBody = Blob.valueOf(JSON.serializePretty(errors));
                return false;
            }
        }

        if (
            req.params.containsKey('orderBy') &&
            req.params.get('orderBy') != null &&
            req.params.get('orderBy') != ''
        ) {
            String orderByParam = req.params.get('orderBy');

            // Ensure orderBy value is a valid option
            if (OrderByOption.contains(orderByParam)) {
                orderBy = orderByParam;
            } else {
                res.statusCode = 400;
                errors = new ErrorResponse('Bad Request, invalid option');
                res.responseBody = Blob.valueOf(JSON.serializePretty(errors));
                return false;
            }
        }

        if (
            req.params.containsKey('limit') &&
            req.params.get('limit') != null &&
            req.params.get('limit') != ''
        ) {
            limiter = Integer.valueof(req.params.get('limit'));
        }

        return true;
    }

    public class ErrorResponse {
        public String message;

        public errorResponse(string message) {
            this.message = message;
        }
    }
}