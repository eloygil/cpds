import java.util.Random;

public class Account {
	private int max_transaction;
	private int balance;
	
	public Account(int max_transaction) {
		this.max_transaction = max_transaction;
	}
	
	public synchronized void deposit() throws InterruptedException {
		Random  random = new Random();
		int amount = (int)(random.nextDouble() * max_transaction);
		balance += amount;
		System.out.println(Thread.currentThread().getName() + " has deposited " + amount);
		print_balance();
		// wake up threads in Waiting Set in order to assure runnable persons
		notifyAll();
	}
	
	public synchronized void withdraw() throws InterruptedException {
		// Condition synchronization: at least there is one euro
		while (balance == 0) {
			System.out.println(Thread.currentThread().getName() + " has to wait");
			wait();
		}
		Random  random = new Random();
		int amount = (int)(random.nextDouble() * balance);
		balance -= amount;
		System.out.println(Thread.currentThread().getName() + " has withdrawed " + amount);
		print_balance();
	}
		
	
	public synchronized void print_balance() {
		System.out.println("balance in the account: " + balance);
	}
}
