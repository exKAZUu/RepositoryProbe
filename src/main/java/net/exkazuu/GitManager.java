package net.exkazuu;

import java.io.BufferedReader;
import java.io.File;
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
			Process p = rt.exec(command);
			p.waitFor();
			BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while((line = br.readLine()) != null) {
				System.out.println(line);
			}			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public Boolean test(String name) {
		String command = "cmd /c mvn test";
		String path = "C:\\Study\\" + name;
		try {
			Process p =rt.exec(command, null, new File(path));
			p.waitFor();
			BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
			
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
		} catch (InterruptedException e) {
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