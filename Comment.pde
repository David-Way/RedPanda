public class Comment{

	private int comment_id;
	private int therapist_id;
	private int user_id;
	private String comment;
	private int date_entered;
	private int record_date;
	private String error = null;

	public Comment(){
		this.comment_id = -1;
	}

	public Comment (int id, int t_id, int u_id, String c, int d_e, int r_d, String er){
		this.comment_id = id;
		this.therapist_id = t_id; 
		this.user_id = u_id;
		this.comment = c;
		this.date_entered = d_e;
		this.record_date = r_d;
		this.error = er;
	}

	public int getComment_id(){
		return comment_id;
	}

	public int getTherapist_id(){
		return therapist_id;
	}

	public int getUser_id(){
		return user_id;
	}

	public String getComment(){
		return comment;
	}

	public int getDateEntered(){
		return date_entered;
	}

	public int getRecordDate(){
		return record_date;
	}

	public String getError(){
		return error;
	}

	public void setComment_id(int comment_id){
		this.comment_id = comment_id;
	}

	public void setTherapist_id(int therapist_id){
		this.therapist_id = therapist_id;
	}

	public void setUser_id(int user_id){
		this.user_id = user_id;
	}

	public void setComment(String comment){
		this.comment = comment;
	}

	public void setDateEntered(int date_entered){
		this.date_entered = date_entered;
	}

	public void setRecordDate(int record_date){
		this.record_date = record_date;
	}

	public void setError(String error){
		this.error = error;
	}
}