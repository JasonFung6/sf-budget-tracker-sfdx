public without sharing class ExpenditureService {
    /*
     * @method  : getExpenditure
     * @desc    : Return a single expenditure item
     * @link    : https://app.swaggerhub.com/apis/JasonFung6/Expenditure/1.0.0-oas3#/default/getById
     */
    public static void getExpenditure(RestRequest req, RestResponse res) {
        ErrorResponse errors;
        ExpenditureServiceModel data = new ExpenditureServiceModel();

        Id accountId;
        Id expenditureId;

        try {
            // Get the account and expenditure Id from URL
            accountId = req.params.get('accId');
            expenditureId = req.params.get('expId');
        } catch (Exception e) {
            res.statusCode = 400;
            errors = new ErrorResponse('Bad Request');
            res.responseBody = Blob.valueOf(JSON.serializePretty(errors));

            return;
        }

        res.addHeader('Content-Type', 'application/json; charset=utf-8');

        try {
            Account acc = QueryUtils.getAccountById(accountId);
            Expenditure__c exp = QueryUtils.getExpenditureByAccIdAndExpId(
                accountId,
                expenditureId
            );

            // Assign queried data to wrapper class
            data.id = exp.Id;
            data.bank = exp.Bank__r.Branch_Name__c;
            data.amount = exp.Amount__c;
            data.createdDate = exp.CreatedDate.getTime(); // Convert DateTime to Unix timestamp
            data.receiptURL = '';
            data.category = exp.Category__c;
            data.description = exp.Description__c;

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serializePretty(data));
        } catch (Exception e) {
            res.statusCode = 404;
            errors = new ErrorResponse('Expenditure item not found');
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