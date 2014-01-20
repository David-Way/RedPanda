public class UserDAO {

        String[] resultArray;

        int u_user_id = -1;  
        String u_username = "";
        String u_password = "";
        int u_therapist_id = -1;
        String u_first_name ="";
        String u_last_name = "";
        String u_dob = "";
        String u_height = "";
        String u_weight = "";
        String u_sex = "";
        String u_injury_type = "";
        String u_error ="";
        private final String USER_AGENT = "Mozilla/5.0";
        
        public UserDAO () {
        }
        
        public User logIn(String un, String pw) {
                String url = "http://davidway.me/kinect/api/user.php/user_table/"+ un+"/" + pw;
                User user = new User();
                HttpClient client = new DefaultHttpClient();
                HttpGet request = new HttpGet(url);

                // add request header
                request.addHeader("User-Agent", USER_AGENT);
                HttpResponse response = null;
                try {
                        response = client.execute(request);

                        System.out.println("\nSending 'GET' request to URL : " + url);
                        System.out.println("Response Code : " + 
                                response.getStatusLine().getStatusCode());

                        BufferedReader rd = new BufferedReader(
                        new InputStreamReader(response.getEntity().getContent()));

                        StringBuffer result = new StringBuffer();
                        String line = "";
                        while ( (line = rd.readLine ()) != null) {
                                result.append(line);
                        }
                        
                        
                               Gson gson = new Gson();
                               user = gson.fromJson(result.toString(), User.class);                        
                        
                        
                        System.out.println("old " + result.toString());
                        System.out.println("new" + user.getFirst_name());
                } 
                catch (Exception e) {
                        System.out.println(e.getMessage());
                }
                
                return user;
        }
        
}

