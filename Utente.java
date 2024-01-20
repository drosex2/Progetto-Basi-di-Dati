import java.util.*;

public class Utente {
	private String username;
	private String email;
	private String password;
	
	
	
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	
	
	public Utente(String username, String email, String password) {
		super();
		this.username = username;
		this.email = email;
		this.password = password;
		
	}
	@Override
	public String toString() {
		return "Utente [username=" + username + ", email=" + email + ", password=" + password + "]";
	}
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Utente other = (Utente) obj;
		return Objects.equals(username, other.username);
	}
	
	
	
}
