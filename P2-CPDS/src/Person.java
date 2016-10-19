public class Person extends Thread {
	Account account;

	public Person(Account account) {
		this.account = account;
	}

	public void run() {
		while (true) {
			try {
				//We assume that a person withdraws more times than deposits
				System.out.println(Thread.currentThread().getName() + " wants to deposit money");
				account.deposit();
				Thread.sleep(200);
				System.out.println(Thread.currentThread().getName() + " wants to withdraw money");
				account.withdraw();
				Thread.sleep(200);
				System.out.println(Thread.currentThread().getName() + " wants to withdraw money");
				account.withdraw();
				Thread.sleep(200);
				System.out.println(Thread.currentThread().getName() + " wants to withdraw money");
				account.withdraw();
				Thread.sleep(200);
			} catch (InterruptedException e) {
			}
			;
		}
	}

}
