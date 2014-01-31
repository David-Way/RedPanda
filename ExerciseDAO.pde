import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;

import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.client.HttpClient;

import java.lang.reflect.Array;
import java.lang.reflect.GenericArrayType;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;


class ExerciseDAO {

        int user_id = -1;
        ArrayList<Exercise> exercises;
        private final String USER_AGENT = "Mozilla/5.0";

        public ExerciseDAO () {
        }

        public ArrayList<Exercise> getExercises(int programmeId) {
                exercises = new ArrayList<Exercise>();               

                String url = "http://davidway.me/kinect/api/exercise.php/programme_exercise_table/" + programmeId;
                User user = null;
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
                                JSONArray jsonArray = new JSONArray(jsonString);
                                ArrayList<Integer> ids = new ArrayList<Integer>();

                                //get the ids for the prescribed exercises
                                for (int i = 0; i < jsonArray.length(); i++) {
                                        JSONObject jsonObject = jsonArray.getJSONObject(i);
                                        //System.out.println(jsonObject.getString("exercise_id"));
                                        ids.add(jsonObject.getInt("exercise_id"));
                                }

                                //get the exercises
                                for (int i = 0; i < ids.size(); i++) {
                                        url = "http://davidway.me/kinect/api/exercise.php/exercise_table/" + ids.get(i);
                                        //User user = null;
                                        client = new DefaultHttpClient();
                                        request = new HttpGet(url);

                                        // add request header
                                        request.addHeader("User-Agent", USER_AGENT);
                                        response = null;

                                        try {
                                                response = client.execute(request);

                                                System.out.println("\nSending 'GET' request to URL : " + url);
                                                System.out.println("Response Code : " + 
                                                        response.getStatusLine().getStatusCode());

                                                rd = new BufferedReader(
                                                new InputStreamReader(response.getEntity().getContent()));

                                                result = new StringBuffer();
                                                line = "";
                                                while ( (line = rd.readLine ()) != null) {
                                                        result.append(line);
                                                }
                                                
                                                //System.out.println(result.toString());
                                               // Gson gson = new Gson();
                                                //exercises.add(gson.fromJson(result.toString(), Exercise.class));
                                                
                                                jsonArray = null;
				                jsonArray = new JSONArray(result.toString());
                                                JSONObject jsonObject = jsonArray.getJSONObject(0);
                                                
                                                int e_id = jsonObject.getInt("exercise_id");
                                                //System.out.println("e_id =  "+ e_id);
                                                String nm = jsonObject.getString("name");
                                                //System.out.println("nm =  "+ nm);
                                                String desc = jsonObject.getString("description");
                                                //System.out.println("desc =  "+ desc);
                                                String  lvl = jsonObject.getString("level");
                                                //System.out.println("lvl =  "+ lvl);                                                
                                                int reps = jsonObject.getInt("repetitions");
                                                //System.out.println("reps =  "+ reps);
                                                
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

