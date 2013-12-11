public class User {

        private int user_id;
        private String user_name;
        private String password;
        private int therapist_id;
        private String first_name;
        private String last_name;
        private String error = null;

        public User () {
        }

        public User (int id, String un, String pw, int tid, String fn, String ln, String er) {
                this.user_id = id;
                this.user_name = un;
                this.password = pw;
                this.therapist_id = tid;
                this.first_name = fn;
                this.last_name = ln;
                this.error = er;
        }

        public int getUser_id() {
                return user_id;
        }

        public void setUser_id(int user_id) {
                this.user_id = user_id;
        }

        public String getUser_name() {
                return user_name;
        }

        public void setUser_name(String user_name) {
                this.user_name = user_name;
        }

        public String getPassword() {
                return password;
        }

        public void setPassword(String password) {
                this.password = password;
        }

        public int getTherapist_id() {
                return therapist_id;
        }

        public void setTherapist_id(int therapist_id) {
                this.therapist_id = therapist_id;
        }

        public String getFirst_name() {
                return first_name;
        }

        public void setFirst_name(String first_name) {
                this.first_name = first_name;
        }

        public String getLast_name() {
                return last_name;
        }

        public void setLast_name(String last_name) {
                this.last_name = last_name;
        }

        public String getError() {
                return this.error;
        }

        public void setError(String err) {
                this.error = err;
        }
}

