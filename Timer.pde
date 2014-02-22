//Timer Class
/// not: must call update and pass the seconds elapsed since last timer update call as argument for timer to work
class Timer {
  float waitTime;
  float curWaitTime;
  boolean looping;
  boolean finished;
  boolean running;

  //Setup timer, set running to true to start immediatley
  public Timer( float _waitTime, boolean _looping, boolean _running ) {
    waitTime = _waitTime;
    curWaitTime = waitTime;
    looping = _looping;
    finished = false;
    running = _running;
  }

  //Returns true if timer expired or finished, false is running or stopped.
  public boolean update(float deltaTime ) {
    if ( !running ) {
      return false;
    }
    //descrease timer
    curWaitTime -= deltaTime;
    //If timer expired
    if ( curWaitTime <= 0.f ) { 
      //If timer set to loop, start timer again and return true
      if ( looping ) { 
        curWaitTime += waitTime;
        return true;
      } 
      // if not looping then set finished flag
      else {
        curWaitTime = 0.f;
        finished = true;
      }
    }
    return finished;
  }

  // resets the timer and starts it
  public void reset() {
    curWaitTime = waitTime;
    finished = false;
    running = true;
  }
}

