//This class is used to access data concerning the record comments
public class CommentDAO {

        //Array list of comment objects to return
        ArrayList<Comment> comments;
        private final String USER_AGENT = "Mozilla/5.0";

        //Constructor
        public CommentDAO() {
        }

        //This function returns an arraylist of records for the passed in user id and exercise id
        public ArrayList<Comment> getComments(int userId, int exerciseId) {

                //New arraylist to return
                comments = new ArrayList<Comment>();               

                //URL to make SLiM API request
                String url = "http://davidway.me/kinect/api/comments.php/comments_table/"+userId+"/"+exerciseId;
                HttpClient client = new DefaultHttpClient();
                HttpGet request = new HttpGet(url);

                // add request header
                request.addHeader("User-Agent", USER_AGENT);//Set user agent
                HttpResponse response = null;

                try {
                        //execute the request using the client, store the response
                        response = client.execute(request);

                        System.out.println("\nSending 'GET' request to URL : " + url);
                        System.out.println("Response Code : " + 
                                response.getStatusLine().getStatusCode());

                        //Create a buffered reader for the content of the HTTP request
                        BufferedReader rd = new BufferedReader(
                        new InputStreamReader(response.getEntity().getContent()));

                        //Create a string buffers
                        StringBuffer result = new StringBuffer();
                        String line = "";
                        //Loop through append the values of lines into the string buffer
                        while ( (line = rd.readLine ()) != null) {
                                result.append(line);
                        }

                        //Convert result to string
                        //Then convert jsonString to a json array
                        try {
                                String jsonString = result.toString();                        
                                org.json.JSONArray jsonArray = new org.json.JSONArray(jsonString);

                                //loop through the jsonArray
                                for (int i = 0; i < jsonArray.length(); i++) {

                                        //Convert each jsonObject in the array to a comment object
                                        //add each object to the comments arraylist
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
                //return the comments arraylist
                return comments;
        }
}

