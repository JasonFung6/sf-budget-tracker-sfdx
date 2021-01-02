/**
 * @class   QueryUtils
 * @desc    Utilities class to hold SOQL related methods
 * @date    22/12/2020
 */
public without sharing class QueryUtils {
    public static Account getAccountById(Id accId) {
        return [SELECT Id FROM Account WHERE Id = :accId];
    }

    public static Account getAccountDetails(Id accId) {
        return [
            SELECT
                Id,
                Income__c,
                Income_Periodicity__c,
                (SELECT Branch_Name__c, Balance__c FROM Banks__r)
            FROM Account
            WHERE Id = :accId
        ];
    }

    public static Expenditure__c getExpenditureByAccIdAndExpId(
        Id accId,
        Id expId
    ) {
        return [
            SELECT
                Id,
                Amount__c,
                Bank__r.Branch_Name__c,
                Category__c,
                Expense_DateTime__c,
                Description__c
            FROM Expenditure__c
            WHERE Account__c = :accId AND Id = :expId
        ];
    }

    public static List<Expenditure__c> getExpendituresWithFilters(
        Id accId,
        String category,
        String period,
        String orderBy,
        Integer limiter
    ) {
        String query = 'SELECT Id, Amount__c, Category__c, Expense_DateTime__c FROM Expenditure__c WHERE Account__c = :accId ';

        if (category != null) {
            query += 'AND Category__c = :category ';
        }

        if (period != null) {
            if (period == 'daily') {
                query += 'AND Expense_DateTime__c = TODAY ';
            }

            if (period == 'monthly') {
                query += 'AND Expense_DateTime__c = THIS_MONTH ';
            }

            if (period == 'yearly') {
                query += 'AND Expense_DateTime__c = THIS_YEAR ';
            }
        }

        if (orderBy != null) {
            if (orderBy == 'ascending') {
                query += 'ORDER BY Expense_DateTime__c ASC ';
            } else if (orderBy == 'descending') {
                query += 'ORDER BY Expense_DateTime__c DESC ';
            }
        }

        if (limiter != null) {
            query += 'LIMIT :limiter ';
        }

        return Database.query(query);
    }
}