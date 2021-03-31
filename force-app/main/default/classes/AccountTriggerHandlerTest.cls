/*
 * @author         : Jason Fung
 * @description    : Test class for AccountTriggerHandler
 */
@isTest
public class AccountTriggerHandlerTest {
    @testSetup
    static void testSetup() {
        createTwentyActiveAccountsWithTwoContacts();
        createTwentyInactiveAccountsWithTwoContacts();
        createActiveAccountWithNoContacts();
    }

    @IsTest
    static void updateAccountToInactive() {
        Account acc = getAccount('Unit-Test-Active-Account-1');

        acc.Status__c = 'Inactive';
        update acc;

        List<Contact> cons = getContacts(new Set<Id>{ acc.Id });

        for (Contact c : cons) {
            System.assertEquals('Inactive', c.Status__c);
        }
    }

    @IsTest
    static void updateAccountToActive() {
        Account acc = getAccount('Unit-Test-Inactive-Account-1');

        acc.Status__c = 'Active';
        update acc;

        List<Contact> cons = getContacts(new Set<Id>{ acc.Id });

        for (Contact c : cons) {
            System.assertEquals('Active', c.Status__c);
        }
    }

    @IsTest
    static void updateAccountStatusEnMasse() {
        Set<Id> accIds = new Set<Id>();
        List<Account> accs = getAccounts('Active');

        for (Account a : accs) {
            accIds.add(a.Id);
            a.Status__c = 'Inactive';
        }

        update accs;

        List<Contact> cons = getContacts(accIds);

        for (Contact c : cons) {
            System.assertEquals('Inactive', c.Status__c);
        }
    }

    @IsTest
    static void updateAccountWithSameStatus() {
        Account acc = getAccount('Unit-Test-Active-Account-1');

        acc.Status__c = 'Active';
        update acc;

        List<Contact> cons = getContacts(new Set<Id>{ acc.Id });

        for (Contact c : cons) {
            System.assertEquals('Active', c.Status__c);
        }
    }

    @IsTest
    static void updateAccountStatusWithNoContacts() {
        Account acc = getAccount('Unit-Test-Account-No-Contacts');

        acc.Status__c = 'Inactive';
        update acc;

        // Account status should still be updated
        // despite no related contacts.
        System.assertEquals('Inactive', acc.Status__c);
    }

    private static void createActiveAccountWithNoContacts() {
        TestUtil.createAccount(
            'Unit-Test-Account-No-Contacts',
            'Active',
            true,
            null
        );
    }

    private static void createTwentyInactiveAccountsWithTwoContacts() {
        for (Integer i = 0; i <= 19; i++) {
            Account acc = TestUtil.createAccount(
                'Unit-Test-Inactive-Account-' + i,
                'Inactive',
                true,
                null
            );

            for (Integer j = 0; j <= 1; j++) {
                TestUtil.createContact(
                    'Lastname-' + generateUniqueId(),
                    true,
                    new Map<String, Object>{ 'AccountId' => acc.Id }
                );
            }
        }
    }

    private static void createTwentyActiveAccountsWithTwoContacts() {
        for (Integer i = 0; i <= 19; i++) {
            Account acc = TestUtil.createAccount(
                'Unit-Test-Active-Account-' + i,
                'Active',
                true,
                null
            );

            for (Integer j = 0; j <= 1; j++) {
                TestUtil.createContact(
                    'Lastname-' + generateUniqueId(),
                    true,
                    new Map<String, Object>{ 'AccountId' => acc.Id }
                );
            }
        }
    }

    private static Account getAccount(String name) {
        return [SELECT Status__c FROM Account WHERE Name = :name];
    }

    private static List<Contact> getContacts(Set<Id> accIds) {
        return [SELECT Status__c FROM Contact WHERE AccountId IN :accIds];
    }

    private static List<Account> getAccounts(String status) {
        return [SELECT Status__c FROM Account WHERE Status__c = :status];
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