//Albert Cerezo & Eloy Gil

public class Vars {
	
private boolean flag_alice;
private boolean flag_bob;
private int turn;

	public Vars() {
		flag_alice = false;
		flag_bob = false;
		turn = 1;
	}
	
	public synchronized boolean query_flag(String s) {
		//no condition synchronization is needed
		if (s.equals("alice")) return flag_bob;
		return flag_alice;
	}
	
	public synchronized void set_true(String s) {
		//no condition synchronization is needed
		if (s.equals("alice")) { flag_alice = true;}
		else { flag_bob = true; }
	}
	
	public synchronized void set_false(String s) {
		//no condition synchronization is needed
		if (s.equals("alice")) { flag_alice = false; }
		else { flag_bob = false; }
	}
	
	public synchronized int get_turn() { return turn; }
	
	public synchronized void set_turn(String s) {
		if (s.equals("alice")) { turn = 2; }
		else { turn = 1; }
	}
}