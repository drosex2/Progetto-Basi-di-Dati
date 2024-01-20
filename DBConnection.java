
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
//import java.util.Objects;

public class DBConnection
{
    // istanza statica e privata di questa classe
    private static DBConnection dbcon = null;
    // istanza privata della connessione ad SQL
    private Connection conn = null;

    // costruttore private
    private DBConnection(){}

    // metodo pubblico per ottenere una istanza della classe privata
    public static DBConnection getDBConnection()
    {   // se la classe connessione è nulla, la crea
        if (dbcon == null) {
            dbcon = new DBConnection();
        }
        // e la restituisce
        return dbcon;
    }

    // metodo pubblico per ottenere la connessione
    public Connection getConnection()
    {
        String pwd = null;
        try
        {   // se la connessione non esiste oppure è stata chiusa
            if(conn==null || conn.isClosed())
            {   
                pwd = "root";
                // registra il driver
                Class.forName("org.postgresql.Driver");
                // chiama il DriverManager e chiedi la connessione
                conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/UninaSocialGroup", "postgres2", pwd); // generico schema postgres
                //conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/db_bdd_unina", "postgres", pwd);
            }
        } catch (SQLException | ClassNotFoundException  throwables) {
            throwables.printStackTrace();
        }

        return conn;
    }

	
}
