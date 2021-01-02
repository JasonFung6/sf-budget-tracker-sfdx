public without sharing class AccountService {
    /*
     * @method  : getAccountDetails
     * @desc    : Return all information about an Account
     * @link    :
     */
    public static void getAccountDetails(RestRequest req, RestResponse res) {
        ErrorResponse errors;
        AccountServiceModel data = new AccountServiceModel();
        List<AccountServiceModel.Bank> banks = new List<AccountServiceModel.Bank>();

        Id accountId;

        try {
            // Get the account Id from URL
            accountId = req.params.get('accId');
        } catch (Exception e) {
            res.statusCode = 400;
            errors = new ErrorResponse('Bad Request');
            res.responseBody = Blob.valueOf(JSON.serializePretty(errors));

            return;
        }

        res.addHeader('Content-Type', 'application/json; charset=utf-8');

        try {
            Account acc = QueryUtils.getAccountDetails(accountId);

            for (Bank__c b : acc.Banks__r) {
                banks.add(
                    new AccountServiceModel.Bank(b.Branch_Name__c, b.Balance__c)
                );
            }

            data.id = acc.Id;
            data.income = acc.Income__c;
            data.incomePeriodicity = acc.Income_Periodicity__c;
            data.banks = banks;

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serializePretty(data));
        } catch (Exception e) {
            res.statusCode = 404;
            errors = new ErrorResponse('Account not found');
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