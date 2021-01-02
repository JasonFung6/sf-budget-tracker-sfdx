public class AccountServiceModel {
    public String id;
    public Decimal income;
    public String incomePeriodicity;
    public List<Bank> banks;

    public AccountServiceModel() {
    }

    public class Bank {
        public String branch;
        public Decimal balance;

        public Bank(String branch, Decimal balance) {
            this.branch = branch;
            this.balance = balance;
        }
    }
}