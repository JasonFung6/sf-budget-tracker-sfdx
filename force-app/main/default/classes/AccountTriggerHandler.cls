public with sharing class AccountTriggerHandler {
    /**
     * @method  handleContactStatus
     * @desc    Update contact status to match the status of the related account
     * @param   Map<Id, Account> newAccountsMap
     * @param   Map<Id, Account> oldAccountsMap
     */
    public void handleContactStatus(
        Map<Id, Account> newAccountsMap,
        Map<Id, Account> oldAccountsMap
    ) {
        List<Account> accWithCons = [
            SELECT Id, Status__c, (SELECT Id, Status__c FROM Contacts)
            FROM Account
            WHERE Id IN :newAccountsMap.keyset()
        ];

        List<Contact> consToUpdate = new List<Contact>();

        for (Account acc : accWithCons) {
            // Skip account if status has not changed
            if (acc.Status__c == oldAccountsMap.get(acc.Id).Status__c) {
                continue;
            }

            // Skip account if there are no associated contacts
            if (acc.Contacts.size() == 0) {
                continue;
            }

            for (Contact con : acc.Contacts) {
                con.Status__c = acc.Status__c;
                consToUpdate.add(con);
            }
        }

        if (consToUpdate.size() > 0) {
            update consToUpdate;
        }
    }
}