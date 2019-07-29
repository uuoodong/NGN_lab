package test;

import java.io.IOException;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ServletTest extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	public void init(ServletConfig config) throws ServletException {

	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		DatagramSocket tojava = new DatagramSocket(); //페이지가 열리면 진재한테 send>>>  값은 1또는 0 
		int port1 = 10002;
		String i = "0";
		InetAddress ip = InetAddress.getByName("127.0.0.1");
		request.setCharacterEncoding("utf-8");
		String r_hidden = request.getParameter("h_field");
		if (r_hidden.equals("0")) {
			i = r_hidden;
		} else {
			i = r_hidden;
		}
		DatagramPacket camdp = new DatagramPacket(i.getBytes(), i.getBytes().length, ip, port1);
		tojava.send(camdp);
		tojava.close();
		response.sendRedirect("Main.jsp");
	}

}
