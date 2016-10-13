
public class Pot {
	private int servings = 0;
	private int capacity;

	public Pot(int capacity) {
		this.capacity = capacity;
	}

	public synchronized void getserving() throws InterruptedException {
		// Condition synchronization: at least one serving available,
		// otherwise, go to the Waiting Set till the cook fill the pot
		while (servings == 0) {
			System.out.println(Thread.currentThread().getName() + " has to wait");
			wait();
		}
		--servings;
		System.out.println(Thread.currentThread().getName() + " is served");
		// when necessary, wake up threads in Waiting Set in order to assure
		// a runnable cook
		if (servings == 0)
			notifyAll();
		print_servings();
	}

	public synchronized void fillpot() throws InterruptedException {
		// Condition synchronization: there is no serving available,
		// otherwise, go to the Waiting Set until the pot is empty
		while (servings > 0) {
			System.out.println(Thread.currentThread().getName() + " has to wait");
			wait();
		}
		servings = capacity;
		System.out.println(Thread.currentThread().getName() + " fills the pot");
		// wake up threads in Waiting Set in order to assure runnable savages
		print_servings();
		notifyAll();
	}

	// only for trace purposes
	public synchronized void print_servings() {
		System.out.println("servings in the pot: " + servings);
	}
}