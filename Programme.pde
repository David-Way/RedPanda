//Programme object, used to store information for each programme
class Programme {

        //declare variable for values
        int programme_id = -1;
        int user_id = -1;
        String create_date = "";
        String end_date = "";
        int version = -1;
        ArrayList<Exercise> exercises = new ArrayList<Exercise>();

        public Programme() {
        }

        //constructor that takes all values and sets them    
        public Programme (int p_id, int u_id, String c_date, String e_date, int v) {
                this.programme_id = p_id;
                this.user_id = u_id;
                this.create_date = c_date;
                this.end_date = e_date;
                this.version = v;
        }

         //getters and setters for the programme values
        public int getProgramme_id() {
                return programme_id;
        }

        public void setProgramme_id(int programme_id) {
                this.programme_id = programme_id;
        }

        public int getUser_id() {
                return user_id;
        }

        public void setUser_id(int user_id) {
                this.user_id = user_id;
        }

        public String getCreate_date() {
                return create_date;
        }

        public void setCreate_date(String create_date) {
                this.create_date = create_date;
        }

        public String getEnd_date() {
                return end_date;
        }

        public void setEnd_date(String end_date) {
                this.end_date = end_date;
        }

        public int getVersion() {
                return version;
        }

        public void setVersion(int version) {
                this.version = version;
        }

        public ArrayList<Exercise> getExercises() {
                return exercises;
        }

        public void setExercises(ArrayList<Exercise> exercises) {
                this.exercises = exercises;
        }
}

