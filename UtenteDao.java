import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

public class UtenteDao {
	private Connection conn = null;
	
	public UtenteDao(){
		
        // istanzia la classe di connessione al DB
        DBConnection dbConnection= DBConnection.getDBConnection();        // recupera la connessione
        //conn = dbConnection.getConnection();
        // se conosco già ed ho già creato lo schema !!!
        conn = dbConnection.getConnection();

        if (conn == null) {
            System.out.println("Connessione NON riuscita!");
            System.exit(0);
        }
	}
	
	
	
	public void save(Utente utente)
	{
		String username=utente.getUsername();
		String email=utente.getEmail();
		String password=utente.getPassword();
	    Statement stmt = null;
        try {

            // crea uno statement semplice
            stmt = this.conn.createStatement();

            String query = "INSERT INTO Utente VALUES ('"+username+"','"+email+"','"+password+"');";

            stmt.execute(query);
            
            stmt.close();

            // chiudiamo la connessione
            conn.close();


        } catch (SQLException throwables) {
            throwables.printStackTrace();
            System.err.println( throwables.getClass().getName()+": "+ throwables.getMessage() );
            System.exit(0);
        }
	}
	public Utente getByUsername(String username)
	{
		Utente utenteReturn;
	    Statement stmt = null;
        try {

            // crea uno statement semplice
            stmt = this.conn.createStatement();

            PreparedStatement ps_queryforname = conn.prepareStatement("Select * from Utente where username ='"+username+"';");
            

            ResultSet rs = ps_queryforname.executeQuery();

            String usernameReturn=rs.getString(1);
            String emailReturn=rs.getString(2);
            String passwordReturn=rs.getString(3);
            
            utenteReturn=new Utente(usernameReturn,emailReturn,passwordReturn);
            
            stmt.close();

            // chiudiamo la connessione
            conn.close();
            return utenteReturn;

        } catch (SQLException throwables) {
            throwables.printStackTrace();
            System.err.println( throwables.getClass().getName()+": "+ throwables.getMessage() );
            System.exit(0);
            return null;
        }
        
	}
	public List<Utente> getByGruppo(String nomeGruppo)
	{
		List<Utente> listaReturn = null;
		Utente utenteReturn;
	    Statement stmt = null;
        try {

            // crea uno statement semplice
            stmt = this.conn.createStatement();

            PreparedStatement ps_queryforname = conn.prepareStatement("SELECT u.* FROM utente AS U JOIN iscrizione AS i ON u.username=i.username JOIN gruppo AS G ON i.\"idGruppo\"=G.\"idGruppo\" WHERE g.nome='"+nomeGruppo+"';");
            

            ResultSet rs = ps_queryforname.executeQuery();

            while(rs.next())
            {
	            String usernameReturn=rs.getString(1);
	            String emailReturn=rs.getString(2);
	            String passwordReturn=rs.getString(3);
	            
	            utenteReturn=new Utente(usernameReturn,emailReturn,passwordReturn);
	            listaReturn.add(utenteReturn);
            }
            stmt.close();

            // chiudiamo la connessione
            conn.close();
            return listaReturn;

        } catch (SQLException throwables) {
            throwables.printStackTrace();
            System.err.println( throwables.getClass().getName()+": "+ throwables.getMessage() );
            System.exit(0);
            return null;
        }
        
	}

	public void updateEmailById(String username,String email) {
		
	    Statement stmt = null;
        try {

            // crea uno statement semplice
            stmt = this.conn.createStatement();

            String query = "UPDATE utente SET email = '"+email+"' WHERE username = '"+username+"';";

            stmt.execute(query);
            
            stmt.close();

            // chiudiamo la connessione
            conn.close();


        } catch (SQLException throwables) {
            throwables.printStackTrace();
            System.err.println( throwables.getClass().getName()+": "+ throwables.getMessage() );
            System.exit(0);
        }	
	}
	public void updatePasswordById(String username,String password) {
		
	    Statement stmt = null;
        try {

            // crea uno statement 
            stmt = this.conn.createStatement();

            String query = "UPDATE utente SET password = '"+password+"' WHERE username = '"+username+"';";

            stmt.execute(query);
            
            stmt.close();

            // chiudi la connessione
            conn.close();


        } catch (SQLException throwables) {
            throwables.printStackTrace();
            System.err.println( throwables.getClass().getName()+": "+ throwables.getMessage() );
            System.exit(0);
        }	
	}
	public void deleteById(String username){
		
	    Statement stmt = null;
        try {

            // crea uno statement semplice
            stmt = this.conn.createStatement();

            String query = "DELETE FROM utente WHERE username IN ('"+username+");";

            stmt.execute(query);
            
           
            stmt.close();

            // chiudiamo la connessione
            conn.close();


        } catch (SQLException throwables) {
            throwables.printStackTrace();
            System.err.println( throwables.getClass().getName()+": "+ throwables.getMessage() );
            System.exit(0);
        }
		
	}
}
