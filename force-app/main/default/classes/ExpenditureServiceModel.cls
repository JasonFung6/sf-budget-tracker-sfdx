public class ExpenditureServiceModel {
    public String id;
    public String bank;
    public Decimal amount;
    public Long expenseDatetime;
    public String receiptURL;
    public String category;
    public String description;

    public ExpenditureServiceModel() {
        this.id = id;
        this.bank = bank;
        this.amount = amount;
        this.expenseDatetime = expenseDatetime;
        this.receiptURL = receiptURL;
        this.category = category;
        this.description = description;
    }
}