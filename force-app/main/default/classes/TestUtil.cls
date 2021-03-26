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
     * @param   Map<String, Object> fields
     */
    public static Account createAccount(
        String name,
        Map<String, Object> fields
    ) {
        Account acc = new Account(
            Name = String.isBlank(name) ? 'Unit-Test-Account' : name
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
     * @param   String email
     * @param   Map<String, Object> fields
     */
    public static Contact createContact(
        String lastName,
        String email,
        Map<String, Object> fields
    ) {
        Contact con = new Contact(
            LastName = lastName,
            Email = String.isBlank(email) ? 'unit-test@email.com' : email,
            Phone = '07111111111',
            Title = 'Mr'
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