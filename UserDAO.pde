public class UserDAO {

        String[] resultArray;

        int u_user_id = -1;  
        String u_username = "";
        String u_password = "";
        int u_therapist_id = -1;
        String u_first_name ="";
        String u_last_name = "";
        String u_error ="";

        public UserDAO () {
        }

        public User logIn(String userName, String password) {
                //returns an array of strings, first string is a json object of user
                //{"user_id":"2","user_name":"patient","password":"patient","therapist_id":"1","first_name":"John","last_name":"Bloggs","errors":null}
                resultArray = loadStrings("http://davidway.me/kinect/login.php?user_name="+userName+"&password="+password);
                //JSONObject json = loadJSONObject("http://davidway.me/kinect/login.php?user_name="+userName+"&password="+password); 
                //println(resultArray);
                if (!resultArray[0].equals("")) {
                        u_user_id = Integer.parseInt(resultArray[0]);
                        //println(u_user_id);
                        u_username = resultArray[1];
                        //println(u_username);
                        u_password  = resultArray[2];
                        //println(u_password);
                        u_therapist_id = Integer.parseInt(resultArray[3]);
                        //println(u_therapist_id);
                        u_first_name = resultArray[4];
                        //println(u_first_name);
                        u_last_name = resultArray[5];
                        //println(u_last_name);
                        u_error = "";
                }

                if (resultArray.length > 6) {
                        //String u_error = resultArray[6];
                        //println(u_error);
                }

                User u = new User(u_user_id, u_username, u_password, u_therapist_id, u_first_name, u_last_name, u_error);
                //println("fname = " +u.getFirst_name());
                return u;
        }
}

