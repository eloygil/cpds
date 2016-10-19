public class Company extends Thread {
	
	Account account;

	public Company(Account account) {
		this.account = account;
	}

	public void run() {
		while (true) {
			System.out.println(Thread.currentThread().getName() + " wants to deposit the salary");
			try {
				//A company lasts more than a person to deposit money
				account.deposit();
				Thread.sleep(5000);
			} catch (InterruptedException e) {
			}
			;
		}
	}

}
