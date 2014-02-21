public class CommentDAO {

        String[] resultArray;
        int c_comment_id = -1;
        int c_record_id = -1;
        int c_therapist_id = -1;
        int c_user_id = -1;
        String c_comment = "";
        int c_date_entered = -1;
        int c_record_date = -1;
        String u_error ="";
        ArrayList<Comment> comments;
        private final String USER_AGENT = "Mozilla/5.0";


        public CommentDAO() {
        }

        public ArrayList<Comment> getComments(int userId, int exerciseId) {
                comments = new ArrayList<Comment>();               

                String url = "http://davidway.me/kinect/api/comments.php/comments_table/"+userId+"/"+exerciseId;
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


                        try {
                                String jsonString = result.toString();                        
                                org.json.JSONArray jsonArray = new org.json.JSONArray(jsonString);

                                //get the ids for the prescribed exercises
                                for (int i = 0; i < jsonArray.length(); i++) {

                                        try {
                                                org.json.JSONObject jsonObject = jsonArray.getJSONObject(i);
                                                Gson gson = new Gson();
                                                Comment comment = gson.fromJson(jsonObject.toString(), Comment.class);                                                
                                                comments.add(comment);
                                        }
                                        catch (Exception e) {
                                                System.out.println(e.getMessage());
                                        }
                                }
                        }
                        catch (JSONException e) {
                                System.out.println(e.getMessage());
                        }
                } 
                catch (IOException e) {
                        System.out.println(e.getMessage());
                }
                //return the retrieved exercises
                return comments;
        }
}

