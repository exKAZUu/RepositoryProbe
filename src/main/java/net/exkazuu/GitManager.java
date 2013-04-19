package net.exkazuu;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

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
		String command = ("git clone " + address + " C:/" + name);
		try {
			rt.exec(command);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public Boolean test(String name) {
		String command = "mvn test C:/" + name;
		try {
			Process p =rt.exec(command);
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			
			String res;
			Boolean flag = false;
			while((res = br.readLine()) != null) {
				if(res.contains("SUCCESSFULL")) {
					flag = true;
				}
			}
			
			if(flag) {
				System.out.println(name);
			}
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