/*
 * @author         : Jason Fung
 * @description    : To support data creation in test classes
 */
@isTest
public class TestUtil {
    /**
     * @method  createAccount
     * @desc    create a single account record
     * @param   String name
     * @param   String status
     * @param   Map<String, Object> fields
     */
    public static Account createAccount(
        String name,
        String status,
        Map<String, Object> fields
    ) {
        Account acc = new Account(
            Name = String.isBlank(name) ? 'Unit-Test-Account' : name,
            Status__c = status
        );

        if (fields != null && !fields.isEmpty()) {
            for (String s : fields.keySet()) {
                acc.put(s, fields.get(s));
            }
        }

        insert acc;
        return acc;
    }

    /**
     * @method  createdContact
     * @desc    create a single contact record
     * @param   String lastname
     * @param   Map<String, Object> fields
     */
    public static Contact createContact(
        String lastName,
        Map<String, Object> fields
    ) {
        Contact con = new Contact(
            LastName = String.isBlank(lastName)
                ? 'Unit-Test-LastName'
                : lastName
        );

        if (fields != null && !fields.isEmpty()) {
            for (String s : fields.keySet()) {
                con.put(s, fields.get(s));
            }
        }

        insert con;
        return con;
    }
}