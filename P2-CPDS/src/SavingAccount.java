public class SavingAccount {
	public static void main(String args[]) throws InterruptedException {
		Account account = new Account(1000);
		Thread p1 = new Person(account);
		p1.setName("alice");
		Thread p2 = new Person(account);
		p2.setName("bob");
		Thread c = new Company(account);
		c.setName("company");
		p1.start();
		p2.start();
		c.start();
	}
}
