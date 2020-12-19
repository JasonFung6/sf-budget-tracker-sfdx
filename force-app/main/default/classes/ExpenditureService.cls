@RestResource(urlMapping='/expenditure/*')
global class ExpenditureService {
    /*
     * @description : Returns response body containing expenditure data otherwise an error code and message
     * @example     : http://api.jasonfung.co.uk/expenditure/services/apexrest/expenditure?accId={accId}&expId={expId}
     * TODO         : Abstract out, tidy data wrapper assignment and convert DateTime to Unix format
     */
    @HttpGet
    global static void get() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        ErrorResponse errors;
        ExpenditureServiceModel data = new ExpenditureServiceModel();

        Id accountId;
        Id expenditureId;

        try {
            // Get the account and expenditure Id from URL
            accountId = RestContext.request.params.get('accId');
            expenditureId = RestContext.request.params.get('expId');
        } catch (Exception e) {
            res.statusCode = 400;
            errors = new ErrorResponse('Bad Request');
            res.responseBody = Blob.valueOf(JSON.serialize(errors));

            return;
        }

        res.addHeader('Content-Type', 'application/json; charset=utf-8');

        try {
            Account acc = [SELECT Id FROM Account WHERE Id = :accountId];
            Expenditure__c exp = [
                SELECT Id, Bank__r.Name, Amount__c, CreatedDate, Category__c
                FROM Expenditure__c
                WHERE Account__c = :accountId AND Id = :expenditureId
            ];

            data.id = exp.Id;
            data.bank = exp.Bank__r.Name;
            data.amount = exp.Amount__c;
            data.createdDate = exp.CreatedDate;
            data.receiptURL = '';
            data.category = exp.Category__c;

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serializePretty(data));
        } catch (QueryException e) {
            res.statusCode = 404;
            errors = new ErrorResponse(
                'Account or Expenditure record not found'
            );
            res.responseBody = Blob.valueOf(JSON.serialize(errors));

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