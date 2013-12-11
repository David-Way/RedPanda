class ProgrammeDAO {

        int user_id = -1;
        String[] resultsArray;

        public ProgrammeDAO (int u_id) {
                this.user_id = u_id;
        }

        public Programme getProgramme() {
                Programme p = new Programme();
                resultsArray = loadStrings("http://davidway.me/kinect/getProgramme.php?user_id="+user_id);

                println(resultsArray);
                return p;
        }
}

