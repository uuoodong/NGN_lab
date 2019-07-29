package test;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;

public class JSPUDP {
	String JSPUDP(int arg_port) {
		int jspport = arg_port;  // jsp connect
		DatagramSocket jspsocket = null;
		byte[] buf = new byte[512];
		try {
			jspsocket = new DatagramSocket(jspport);
			DatagramPacket jspdp = new DatagramPacket(buf, buf.length);
			jspsocket.receive(jspdp);
			String sentence = new String(jspdp.getData());
			return sentence;
			
		} catch (IOException e) {
			System.out.println(e);
			return null;
			
		} finally{
			jspsocket.close();
		}
	}

}
