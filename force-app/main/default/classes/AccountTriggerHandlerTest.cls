/*
 * @author         : Jason Fung
 * @description    : Test class for AccountTriggerHandler
 */
@isTest
public class AccountTriggerHandlerTest {
    @testSetup
    static void testSetup() {
        createTwentyAccountsWithTwoContacts();
        createAccountWithNoContacts();
    }

    @IsTest
    static void updateAccountToActive() {
        Account acc = getAccount('Unit-Test-Account-1');
        System.assert(String.isBlank(acc.Status__c));

        acc.Status__c = 'Active';
        update acc;

        for (Contact c : getContactsWithAccId(acc.Id)) {
            System.assertEquals('Active', c.Status__c);
        }
    }

    @IsTest
    static void updateAccountToInactive() {
        Account acc = getAccount('Unit-Test-Account-1');
        System.assert(String.isBlank(acc.Status__c));

        acc.Status__c = 'Inactive';
        update acc;

        for (Contact c : getContactsWithAccId(acc.Id)) {
            System.assertEquals('Inactive', c.Status__c);
        }
    }

    @IsTest
    static void updateAccountStatusWithNoContacts() {
        Account acc = getAccount('Unit-Test-Account');
        System.assert(String.isBlank(acc.Status__c));

        acc.Status__c = 'Active';
        update acc;

        // Account status should still be updated
        // despite no related contacts.
        System.assertEquals('Active', acc.Status__c);
    }

    @IsTest
    static void updateAccountStatusEnMasse() {
        List<Account> accs = getAccounts();

        for (Account a : accs) {
            System.assert(String.isBlank(a.Status__c));
            a.Status__c = 'Active';
        }

        update accs;

        List<Contact> cons = getContacts();
        for (Contact c : cons) {
            System.assertEquals('Active', c.Status__c);
        }
    }

    private static void createAccountWithNoContacts() {
        Account acc = TestUtil.createAccount('Unit-Test-Account', null);
    }

    private static void createTwentyAccountsWithTwoContacts() {
        for (Integer i = 0; i <= 19; i++) {
            Account acc = TestUtil.createAccount(
                'Unit-Test-Account-' + i,
                null
            );

            for (Integer j = 0; j <= 1; j++) {
                String uniqueId = generateUniqueId();
                TestUtil.createContact(
                    'Lastname-' + uniqueId,
                    'unit-test-email-' +
                    uniqueId +
                    '@email.com',
                    new Map<String, Object>{ 'AccountId' => acc.Id }
                );
            }
        }
    }

    private static List<Account> getAccounts() {
        return [SELECT Id, Status__c FROM Account];
    }

    private static List<Contact> getContacts() {
        return [SELECT Id, Status__c FROM Contact];
    }

    private static Account getAccount(String accName) {
        return [SELECT Id, Status__c FROM Account WHERE Name = :accName];
    }

    private static List<Contact> getContactsWithAccId(Id accId) {
        return [SELECT Id, Status__c FROM Contact WHERE AccountId = :accId];
    }

    public static String generateUniqueId() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String uniqueId =
            h.SubString(0, 8) +
            '-' +
            h.SubString(8, 12) +
            '-' +
            h.SubString(12, 16) +
            '-' +
            h.SubString(16, 20) +
            '-' +
            h.substring(20);
        return uniqueId;
    }
}