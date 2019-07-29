package Command;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CommandThread extends Thread {
	String Cmd[];
	CommandInsertion CInsert = new CommandInsertion();

	public CommandThread(String Cmd[]) {
		this.Cmd = Cmd;
	}

	public void run() {
		double Capacity = Double.parseDouble(CInsert.exec(Cmd));
		
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet re = null;
		String url = "jdbc:mariadb://localhost:3306/testdb";
		String jdbc = "org.mariadb.jdbc.Driver";
		String user = "root";
		String pass = "root";
		String[] SQLresult = new String[100];
		while (true) {
			if ((((int) Capacity / 24) * 100) >= 97) {
				try {
					Class.forName(jdbc);
					con = DriverManager.getConnection(url, user, pass);
					String sql = "select * from (select @rownum:=@rownum+1 as rownum, logvalue.* "
							+ "from  logvalue, (Select @rownum:=0)R order by monitoringTime ASC)W";
					ps = con.prepareStatement(sql);
					re = ps.executeQuery();
					int i = 0;
					while (re.next()) {
						SQLresult[i] = re.getString("monitoringTime");
						i++;
					}
					for (i = 0; i < 100; i++) {
						String sqlCount = "delete from logvalue where monitoringTime='" + SQLresult[i] + "'";
						ps.executeUpdate(sqlCount);
						String[] Tcommand = { "/bin/sh", "-c",
								"sudo rm /usr/local/tomcat9/webapps/TheftPrevention/video/" + SQLresult[i] + ".mp4" };
						CInsert.exec(Tcommand);
					}
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
					System.out.println("DB Driver Error");
				} catch (SQLException se) {
					se.printStackTrace();
					System.out.println("DB Connection Error");
				} finally {
					try {
						if (re != null) {
							re.close();
						}
					} catch (Exception e) {
					}
					try {
						if (ps != null) {
							ps.close();
						}
					} catch (Exception e) {
					}
					try {
						if (con != null) {
							con.close();
						}
					} catch (Exception e) {
					}
				}
			}
			try {
				Thread.sleep(30000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

	public static void main(String[] args) {
		String[] Command = { "/bin/sh", "-c",
				"df -P | grep -v ^Filesystem | awk '{sum += $3} END {print sum/1024/1024}'" };
		CommandThread CmdTh = new CommandThread(Command);
		CmdTh.start();
	}
}
