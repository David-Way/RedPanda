//this class is used for making database requests and accessing the users prescribed exercise objects
class ExerciseDAO {

        //declare variables 
        ArrayList<Exercise> exercises;
        private final String USER_AGENT = "Mozilla/5.0"; //this is used by the http client

        //exercise DAO connstructor
        public ExerciseDAO () {
        }

        //this function makes a connection to the database and returns the exercises for a given programme using the id given as a paramete
        public ArrayList<Exercise> getExercises(int programmeId) {
                //init array for exercise objects
                exercises = new ArrayList<Exercise>();               

                //create string for the query using the programme id
                String url = "http://davidway.me/kinect/api/exercise.php/programme_exercise_table/" + programmeId;
                User user = null;
                //create  java http client and request objects
                HttpClient client = new DefaultHttpClient();
                HttpGet request = new HttpGet(url);

                // add request header to the request
                request.addHeader("User-Agent", USER_AGENT);
                HttpResponse response = null;

                try {
                        //execute the request and store the response
                        response = client.execute(request);

                        System.out.println("\nSending 'GET' request to URL : " + url);
                        System.out.println("Response Code : " + 
                                response.getStatusLine().getStatusCode());

                        //retrieve the content of the response using an buffered reader
                        BufferedReader rd = new BufferedReader(
                        new InputStreamReader(response.getEntity().getContent()));

                        StringBuffer result = new StringBuffer();
                        String line = "";
                        //while there are lines in the buffered reader, 
                        //read them and append them into the result string buffer
                        while ( (line = rd.readLine ()) != null) {
                                result.append(line);
                        }

                        try {
                                //convert the string buffer to a string
                                String jsonString = result.toString();
                                //create a jason array using this string                        
                                org.json.JSONArray jsonArray = new org.json.JSONArray(jsonString);
                                ArrayList<Integer> ids = new ArrayList<Integer>();

                                //get the ids for the prescribed exercises
                                for (int i = 0; i < jsonArray.length(); i++) {
                                        org.json.JSONObject jsonObject = jsonArray.getJSONObject(i);
                                        //System.out.println(jsonObject.getString("exercise_id"));
                                        ids.add(jsonObject.getInt("exercise_id"));
                                }

                                //get the exercises for each of the returned id's
                                for (int i = 0; i < ids.size(); i++) {
                                        //create the query string for the exercise of the given id
                                        url = "http://davidway.me/kinect/api/exercise.php/exercise_table/" + ids.get(i);
                                        //User user = null;

                                        //create new java http client and request objects
                                        client = new DefaultHttpClient();
                                        request = new HttpGet(url);

                                        // add request header
                                        request.addHeader("User-Agent", USER_AGENT);
                                        response = null;

                                        try {
                                                //execute the request and store the response
                                                response = client.execute(request);

                                                System.out.println("\nSending 'GET' request to URL : " + url);
                                                System.out.println("Response Code : " + 
                                                        response.getStatusLine().getStatusCode());

                                                //retrieve the contents of the response in a buffered reader
                                                rd = new BufferedReader(
                                                new InputStreamReader(response.getEntity().getContent()));

                                                result = new StringBuffer();
                                                line = "";
                                                //while there are still lines in the buffer, read them and append them into the  results string
                                                while ( (line = rd.readLine ()) != null) {
                                                        result.append(line);
                                                }

                                                //create a new json array using the results string
                                                jsonArray = null;
                                                jsonArray = new org.json.JSONArray(result.toString());
                                                //get the firsts json onject in this array
                                                org.json.JSONObject jsonObject = jsonArray.getJSONObject(0);

                                                //retrieve the object values fron the json object
                                                int e_id = jsonObject.getInt("exercise_id");
                                                String nm = jsonObject.getString("name");
                                                String desc = jsonObject.getString("description");
                                                String  lvl = jsonObject.getString("level");                                   
                                                int reps = jsonObject.getInt("repetitions");
                                                //create a new exercise object using these retrieved values and store them in the exercises arraylist
                                                exercises.add(new Exercise(e_id, nm, desc, lvl, reps));                                                                                                                                             
                                                //System.out.println("size" + exercises.size());
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
                return exercises;
        }
}

