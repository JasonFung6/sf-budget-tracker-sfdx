/**
 * @class   QueryUtils
 * @desc    Utilities class to hold SOQL related methods
 * @date    22/12/2020
 */
public without sharing class QueryUtils {
    public static Account getAccountById(Id accId) {
        return [SELECT Id FROM Account WHERE Id = :accId];
    }

    public static Expenditure__c getExpenditureByAccIdAndExpId(
        Id accId,
        Id expId
    ) {
        return [
            SELECT
                Id,
                Amount__c,
                Bank__r.Name,
                Category__c,
                CreatedDate,
                Description__c
            FROM Expenditure__c
            WHERE Account__c = :accId AND Id = :expId
        ];
    }
}