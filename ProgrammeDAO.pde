class ProgrammeDAO {

        int user_id = -1;
        String[] resultsArray;

        public ProgrammeDAO (int u_id) {
                this.user_id = u_id;
        }

        public Programme getProgramme() {
                Programme p = new Programme();
                resultsArray = loadStrings("http://davidway.me/kinect/getProgramme.php?user_id="+user_id);
                p.setProgramme_id(Integer.parseInt(resultsArray[0]));
                p.setUser_id(Integer.parseInt(resultsArray[1]));
                p.setCreate_date(resultsArray[2]);
                p.setEnd_date(resultsArray[3]);
                p.setVersion(Integer.parseInt(resultsArray[4]));
                //println(resultsArray);
                return p;
        }
}

