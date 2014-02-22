//This class is used to access data concerning the users records
public class RecordDAO {

  //Array list of record objects to return
  ArrayList<Record> records;
  private final String USER_AGENT = "Mozilla/5.0";

  //Constructor
  public RecordDAO() {
  }

  //This function returns an arraylist of records for the passed in user id and exercise id
  public ArrayList<Record> getRecords(int userId, int exerciseId) {

    //New arraylist to return
    records = new ArrayList<Record>();               
    //URL to make SLiM API request
    String url = "http://davidway.me/kinect/api/record.php/get_all_records/"+userId+"/"+exerciseId;
    HttpClient client = new DefaultHttpClient();
    HttpGet request = new HttpGet(url);

    // add request header
    request.addHeader("User-Agent", USER_AGENT);//Set user agent
    HttpResponse response = null;

    try {
      response = client.execute(request);//execute the request using the client, store the response

      System.out.println("\nSending 'GET' request to URL : " + url);
      System.out.println("Response Code : " + 
        response.getStatusLine().getStatusCode());

      //Create a buffered reader for the content of the HTTP request
      BufferedReader rd = new BufferedReader(
      new InputStreamReader(response.getEntity().getContent()));

      //Create a string buffer
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

          //Convert each jsonObject in the array to a record object
          //add each object to the records arraylist
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
    //return the records arraylist
    return records;
  }


  //This function returns the last done exercise for a specific user and exercise
  public Record getLastForExercise(int us_id, int ex_id) {
    //URL to make SLIM request
    String url = "http://davidway.me/kinect/api/record.php/get_last_for_exercise/"+us_id+"/"+ex_id;
    Record record = new Record();//Create new record object to return
    HttpClient client = new DefaultHttpClient();//Create new HTTPClient to make request
    HttpGet request = new HttpGet(url);//Make a new request object

    // add request header
    request.addHeader("User-Agent", USER_AGENT);//Set its user agent
    HttpResponse response = null;
    try {   
      //Execute the request using the client, store the response
      response = client.execute(request);

      System.out.println("\nSending 'GET' request to URL : " + url);
      System.out.println("Response Code : " + 
        response.getStatusLine().getStatusCode());

      //Create a buffered reader
      BufferedReader rd = new BufferedReader(
      new InputStreamReader(response.getEntity().getContent()));

      //Create a string buffer
      StringBuffer result = new StringBuffer();
      String line = "";
      //Loop taking the values and appendsing them into the string buffer
      while ( (line = rd.readLine ()) != null) {
        result.append(line);
      }

      //Creates a Gson object, from the google json parsing library
      Gson gson = new Gson();
      //Set the records object equal to the result string parsed into a record object
      record = gson.fromJson(result.toString(), Record.class);                        


      System.out.println("old " + result.toString());
      System.out.println("new" + record.getDateDone());
    } 
    catch (Exception e) {
      System.out.println(e.getMessage());
    }

    //Return the record object
    return record;
  }

  //This function returns the last done record for the user from any exercise
  public Record getLastDone(int us_id) {
    //url to make slim api request
    String url = "http://davidway.me/kinect/api/record.php/get_last_done_record/"+us_id;
    Record record = new Record();//Create new record object to return
    HttpClient client = new DefaultHttpClient();//Create new HTTPClient to make request
    HttpGet request = new HttpGet(url);//Make a new request object


    // add request header
    request.addHeader("User-Agent", USER_AGENT);//Set its user agent
    HttpResponse response = null;
    try {
      //Execute the request using the client, store the response
      response = client.execute(request);

      System.out.println("\nSending 'GET' request to URL : " + url);
      System.out.println("Response Code : " + 
        response.getStatusLine().getStatusCode());

      //Create a buffered reader
      BufferedReader rd = new BufferedReader(
      new InputStreamReader(response.getEntity().getContent()));

      //Create a string buffer
      StringBuffer result = new StringBuffer();
      String line = "";
      //Loop taking the values and appendsing them into the string buffer
      while ( (line = rd.readLine ()) != null) {
        result.append(line);
      }

      //Creates a Gson object, from the google json parsing library
      Gson gson = new Gson();
      //Set the records object equal to the result string parsed into a record object
      record = gson.fromJson(result.toString(), Record.class);                        


      System.out.println("old " + result.toString());
      System.out.println("new" + record.getDateDone());
    } 
    catch (Exception e) {
      System.out.println(e.getMessage());
    }

    //Return the record object
    return record;
  }

  //This function sends a json object to the SLIM API to be put into the databse
  public void setRecord(Record record) {
    //url to make slim api requests
    String url = "http://davidway.me/kinect/api/record.php/record_table";
    //Create new HTTPClient to make request
    HttpClient client = new DefaultHttpClient();
    //Make a new request object
    HttpPost post = new HttpPost(url);
    // add request header
    post.setHeader("User-Agent", USER_AGENT);//Set its user agent
    //Creates a Gson object, from the google json parsing library
    Gson gson = new Gson();

    try {   //Convert record object to gson to json to a String Entity
      //Set post entity to posting string
      StringEntity postingString = new StringEntity(gson.toJson(record));
      post.setEntity(postingString);
    }
    catch (UnsupportedEncodingException e) {
      e.printStackTrace();
    }
    HttpResponse response = null;

    try {   //Execute the post using the client, store the response
      response = client.execute(post);
      System.out.println("\nSending 'POST' request to URL : " + url);
      System.out.println("Post parameters : " + post.getEntity());
      System.out.println("Response Code : " + 
        response.getStatusLine().getStatusCode());

      //create a buffered reader for the content of the Http response
      BufferedReader rd = new BufferedReader(
      new InputStreamReader(response.getEntity().getContent()));

      //create a string buffer
      StringBuffer result = new StringBuffer();
      String line = "";
      //Loop taking the values and appendsing them into the string buffers
      while ( (line = rd.readLine ()) != null) {
        result.append(line);
      }
      System.out.println(result.toString());
    }
    catch (Exception e) {
      System.out.println(e.getMessage());
    }
  }

  //Function to returns dates and scores of records for a specific user and exercise
  //Used to populate the charts
  public ArrayList<float[]> getChart(int userId, int exerciseId) {
    //Create new arraylist of records
    ArrayList<Record> records = getRecords(userId, exerciseId);
    //Create new float arrays to the size of the returns record array
    float[] dates = new float[records.size()];
    float[] score = new float[records.size()];

    //Loop through returned records arraylist
    //put date and score of each records into the arrays
    for (int i = 0; i < records.size(); i++) {
      float  dd = records.get(i).getDateDone();
      float sc = records.get(i).getScore();                        
      dates[i] = dd;
      score[i] = sc;
    }              

    ArrayList<float[]> results = new ArrayList<float[]>();
    //add dates array and score array to results array
    results.add(dates);
    results.add(score);
    //return results array
    return results;
  }
}

