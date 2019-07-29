package test;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.sql.*;

import com.sun.prism.shader.Solid_TextureYV12_AlphaTest_Loader;


public class UDPjp extends Thread
{
	private DatagramSocket pirsocket = null;
	private DatagramSocket camsocket = null;
	int port1 = 9999; // pir precv 
	int port2 = 10000; // camera psend
	int port3 = 10001; // camera precv
	int port4 = 10002; // jsp recv
	byte[] msg = new byte[512]; // pir buf
	byte[] value = new byte[512]; // camera buf
	Database db = new Database();
	
	static String jsprecv = "0";
	
	Thread th = new Thread() {
		@Override
		public void run()
		{
			JSPUDP jsp = new JSPUDP();
			jsprecv = jsp.JSPUDP(port4);
//			while(!isInterrupted())
//			{
//				
//			}
		}
	};
	
	public UDPjp() throws SocketException
	{
		super();
	
	
	}

	public void run() 
	{
		th.start();
		
		while(true) 
		{
//			String jsprecv = jsp.JSPUDP(port4);
			if (jsprecv.trim().equals("1"))
			{
				try
				{
					pirsocket = new DatagramSocket(port1);//pir
					camsocket = new DatagramSocket(port2);//camera
					db.makeConnection();
					DatagramPacket pirdp = new DatagramPacket(msg, msg.length);
					System.out.println("수신 대기중...");
					pirsocket.receive(pirdp);
					String str = new String(pirdp.getData());
					System.out.println("pir"+str);
					//				DatagramPacket d = new DatagramPacket(msg, msg.length);
					//				socket2.receive(d);
					//				int disk = Integer.parseInt(d.getData().toString());
					//				System.out.println(disk);

					char data = str.charAt(0);
					if(data == '1') 
					{
						InetAddress ip = InetAddress.getByName("127.0.0.1");
						DatagramPacket camdp = new DatagramPacket(str.getBytes(), str.getBytes().length, ip, port3);
						camsocket.send(camdp);
						db.InsertMotion(str);
						System.out.println("space");
						DatagramPacket camdgp = new DatagramPacket(value, value.length);
						camsocket.receive(camdgp);
						String st = new String(camdgp.getData());
						System.out.println("camera"+st);
						

						char tr = st.charAt(0);
						if(tr == '1') 
						{
							db.InsertCamera(st);
						}
					}

				} catch (SocketException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				} catch (SQLException e) {
					e.printStackTrace();
				} finally {
					pirsocket.close();
					camsocket.close();
				}
			}
			else
			{
				try {
					sleep(100);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
				
			
		}
		
	}

}
