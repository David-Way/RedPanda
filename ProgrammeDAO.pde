//This class is used to access data concerning the users programme
class ProgrammeDAO {

  //declare variables for user id an results
  int user_id = -1;
  String[] resultsArray;
  private final String USER_AGENT = "Mozilla/5.0"; //used by Httpclient

  //constructor takes the users id as a parameter
  public ProgrammeDAO (int u_id) {
    this.user_id = u_id;
  }

  //this function returns a programme object for the stored user id
  public Programme getProgramme() {
    //url to make slim api request
    String url = "http://davidway.me/kinect/api/programme.php/programme_table/"+ this.user_id;
    Programme p = new Programme(); //create new programme object to return
    HttpClient client = new DefaultHttpClient(); //create new HttpClient to mae request
    HttpGet request = new HttpGet(url); //make a new request object

    // add request header
    request.addHeader("User-Agent", USER_AGENT); //set its user agent
    HttpResponse response = null;
    try {
      response = client.execute(request); //execute the request using the client, store the response

      System.out.println("\nSending 'GET' request to URL : " + url);
      System.out.println("Response Code : " + 
        response.getStatusLine().getStatusCode());

      //create a buffered reader for the content of the Http response
      BufferedReader rd = new BufferedReader(
      new InputStreamReader(response.getEntity().getContent()));

      //create a string buffer
      StringBuffer result = new StringBuffer();
      String line = "";
      //while the buffer still has lines in it, take the values and append them into the string buffer
      while ( (line = rd.readLine ()) != null) {
        result.append(line);
      }

      //create a Gson object, from the google json parsing library
      Gson gson = new Gson();
      //set the programme object equal to the result string parsed into a Programme object
      p = gson.fromJson(result.toString(), Programme.class); 

      System.out.println("old " + result.toString());
      System.out.println("new" +p.getCreate_date());
    } 
    catch (Exception e) {
      System.out.println(e.getMessage());
    }
    //return the programme object
    return p;
  }
}

