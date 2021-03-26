public with sharing class AccountTriggerHandler {
    /**
     * @method  handleContactStatus
     * @desc    Update contact status to match the status of the related account
     * @param   Map<Id, Account> newAccountsMap
     */
    public void handleContactStatus(Map<Id, Account> newAccountsMap) {
        List<Account> accWithCons = [
            SELECT Id, Status__c, (SELECT Id, Status__c FROM Contacts)
            FROM Account
            WHERE Id IN :newAccountsMap.keyset()
        ];

        List<Contact> consToUpdate = new List<Contact>();

        for (Account acc : accWithCons) {
            // Continue to next account if no associated contacts are present
            if (acc.Contacts.size() == 0) {
                continue;
            }

            // Iterate through each related contact and update the status
            if (!String.isBlank(acc.Status__c)) {
                for (Contact con : acc.Contacts) {
                    con.Status__c = acc.Status__c;
                    consToUpdate.add(con);
                }
            }
        }

        if (consToUpdate.size() > 0) {
            update consToUpdate;
        }
    }
}