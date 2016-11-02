//Albert Cerezo & Eloy Gil
public class Neighbor extends Thread {
	
	private Flags flags;
	
	public Neighbor(Flags flags) {
		this.flags = flags;
	}
	
	public void run() {
		while (true) {
		try {
			String name = Thread.currentThread().getName();
			System.out.println("try again, my name is: "+ name);
			Thread.sleep((int)(200*Math.random()));
			flags.set_true(name);
			//To model greedy uncomment the next sleep and comment the previous sleep 
			//Thread.sleep((int)(200*Math.random()));
			if (!flags.query_flag(name)) {
				System.out.println(name + " enter");
				Thread.sleep(400);
				System.out.println(name + " exits");
			}
			Thread.sleep((int)(200*Math.random()));
			flags.set_false(name);;
		}
		catch (InterruptedException e) {};
		}
	}
}