class ProgrammeDAO {

        int user_id = -1;
        String[] resultsArray;
        private final String USER_AGENT = "Mozilla/5.0";

        public ProgrammeDAO (int u_id) {
                this.user_id = u_id;
        }

        public Programme getProgramme() {
                String url = "http://davidway.me/kinect/api/programme.php/programme_table/"+ this.user_id;
                Programme p = new Programme();
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
                        p = gson.fromJson(result.toString(), Programme.class);                        


                        System.out.println("old " + result.toString());
                        System.out.println("new" +p.getCreate_date());
                } 
                catch (Exception e) {
                        System.out.println(e.getMessage());
                }

                return p;
        }
}

