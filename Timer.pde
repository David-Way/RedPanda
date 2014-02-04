class Timer {
  float waitTime, curWaitTime;
  boolean looping, finished, running;

  public Timer( float _waitTime, boolean _looping, boolean _running ) {
    waitTime = _waitTime;
    curWaitTime = waitTime;
    looping = _looping;
    finished = false;
    running = _running;
  }

  public boolean update(float deltaTime ) {
    if( !running ) {
      return false;
    }
    curWaitTime -= deltaTime;
    if( curWaitTime <= 0.f ) {
      if( looping ) {
        curWaitTime += waitTime;
        return true;
      } else {
        curWaitTime = 0.f;
        finished = true;
      }
    }
    return finished;
  }

  public void reset() {
    curWaitTime = waitTime;
    finished = false;
    running = true;
  }
}
