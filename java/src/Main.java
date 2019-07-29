package test;

import java.io.IOException;
import java.net.SocketException;

public class Main {
	public static void main(String[] args) throws IOException, SocketException 
	{
		UDPjp server = new UDPjp();
		server.start();

	}
}
