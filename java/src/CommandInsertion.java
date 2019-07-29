package Command;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class CommandInsertion {
	public String exec(String cmd[]) {
		String result = "";
		try {
			Process p = Runtime.getRuntime().exec(cmd);
			BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
			result = (br.readLine()).toString();
			br.close();

			return result;
		} catch (IOException e) {
			e.printStackTrace();
			return "0";
		}
	}
}
