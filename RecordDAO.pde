public class RecordDAO {

        String[] resultArray;
        int r_record_id = -1;
        int r_user_id = -1;
        int r_exercise_id = -1;
        int r_date_done = -1;
        int r_time_to_complete = -1;
        int r_score = -1;
        int r_reps = -1;
        String u_error ="";
        ArrayList<Record> records;
        private final String USER_AGENT = "Mozilla/5.0";


        public RecordDAO() {
        }

        public ArrayList<Record> getRecords(int userId, int exerciseId) {
                records = new ArrayList<Record>();               

                String url = "http://davidway.me/kinect/api/record.php/get_all_records/"+userId+"/"+exerciseId;
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
                                                Record record = gson.fromJson(jsonObject.toString(), Record.class);                                                
                                                records.add(record);
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
                return records;
        }



        public Record getLastForExercise(int us_id, int ex_id) {
                String url = "http://davidway.me/kinect/api/record.php/get_last_for_exercise/"+us_id+"/"+ex_id;
                Record record = new Record();
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
                        record = gson.fromJson(result.toString(), Record.class);                        


                        System.out.println("old " + result.toString());
                        System.out.println("new" + record.getDateDone());
                } 
                catch (Exception e) {
                        System.out.println(e.getMessage());
                }

                return record;
        }

        public Record getLastDone(int us_id) {
                String url = "http://davidway.me/kinect/api/record.php/get_last_done_record/"+us_id;
                Record record = new Record();
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
                        record = gson.fromJson(result.toString(), Record.class);                        


                        System.out.println("old " + result.toString());
                        System.out.println("new" + record.getDateDone());
                } 
                catch (Exception e) {
                        System.out.println(e.getMessage());
                }

                return record;
        }


        public void setRecord(Record record) {
                String url = "http://davidway.me/kinect/api/record.php/record_table";

                HttpClient client = new DefaultHttpClient();
                HttpPost post = new HttpPost(url);

                post.setHeader("User-Agent", USER_AGENT);

                Gson gson = new Gson();

                try {
                        StringEntity postingString = new StringEntity(gson.toJson(record));
                        post.setEntity(postingString);
                }
                catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                }
                HttpResponse response = null;

                try {
                        response = client.execute(post);
                        System.out.println("\nSending 'POST' request to URL : " + url);
                        System.out.println("Post parameters : " + post.getEntity());
                        System.out.println("Response Code : " + 
                                response.getStatusLine().getStatusCode());

                        BufferedReader rd = new BufferedReader(
                        new InputStreamReader(response.getEntity().getContent()));

                        StringBuffer result = new StringBuffer();
                        String line = "";
                        while ( (line = rd.readLine ()) != null) {
                                result.append(line);
                        }
                        System.out.println(result.toString());
                }
                catch (Exception e) {
                        System.out.println(e.getMessage());
                }
        }

        public ArrayList<float[]> getChart(int userId, int exerciseId) {
                ArrayList<Record> records = getRecords(userId, exerciseId);
                float[] dates = new float[records.size()];
                float[] score = new float[records.size()];
                
                for (int i = 0; i < records.size(); i++) {
                        float  dd = records.get(i).getDateDone();
                        float sc = records.get(i).getScore();                        
                        dates[i] = dd;
                        score[i] = sc;
                }              
                
                ArrayList<float[]> results = new ArrayList<float[]>();
                results.add(dates);
                results.add(score);
                return results;
        }
}

