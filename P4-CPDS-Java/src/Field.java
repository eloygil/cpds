//Albert Cerezo & Eloy Gil

public class Field {
	
	public static void main(String args[]) {
		Vars vars = new Vars();
		Thread a = new Neighbor(vars);
		a.setName("alice");
		Thread b = new Neighbor(vars);
		b.setName("bob");
		a.start();
		b.start();
	}
}