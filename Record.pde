public class Record{

	private int record_id;
	private int user_id;
	private int exercise_id;
	private int date_done;
	private int time_to_complete;
	private int score;
	private int reps;
	private String error = null;

	public Record(){
		this.record_id = -1;
	}

	public Record (int id, int us_is, int ex_id, int dd, int t, int r, int s, String er){
		this.record_id = id;
		this.user_id = us_is; 
		this.exercise_id = ex_id;
		this.date_done = dd;
		this.time_to_complete = t;
		this.reps = r;
		this.score = s;
		this.error = er;
	}

	public int getRecord_id(){
		return record_id;
	}

	public int getUser_id(){
		return user_id;
	}

	public int getExcercise_id(){
		return exercise_id;
	}

	public int getDateDone(){
		return date_done;
	}

	public int getTimeToComplete(){
		return time_to_complete;
	}

	public int getScore(){
		return score;
	}

	public int getReps(){
		return reps;
	}

	public String getError(){
		return error;
	}

	public void setRecord_id(int record_id){
		this.record_id = record_id;
	}

	public void setUser_id(int user_id){
		this.user_id = user_id;
	}

	public void setExercise_id(int exercise_id){
		this.exercise_id = exercise_id;
	}

	public void setDateDone(int date_done){
		this.date_done = date_done;
	}

	public void setTimeToComplete(int time_to_complete){
		this.time_to_complete = time_to_complete;
	}

	public void setScore(int score){
		this.score = score;
	}

	public void setReps(int reps){
		this.reps = reps;
	}

	public void setError(String error){
		this.error = error;
	}
}