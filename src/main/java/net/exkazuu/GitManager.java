package net.exkazuu;

import java.io.IOException;

public class GitManager {
	private static GitManager gm;
	private Runtime rt;
	private GitManager() {
		rt = Runtime.getRuntime();
	}
	
	public static GitManager getInstance() {
		if(gm == null) {
			gm = new GitManager();
		}
		return gm;
	}

	public void clone(String address, String name) {
		String command = "git clone " + address;
		try {
			rt.exec(command);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public Boolean test() {
		String command = "mvn test";
		try {
			rt.exec(command);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return true;
	}
	
	public void stop() {
		try {
			Thread.sleep(300000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
