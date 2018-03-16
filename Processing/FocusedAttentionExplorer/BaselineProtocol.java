import oscP5.*;
import netP5.*;

import java.util.Timer;
import java.util.*;
import javafx.event.*;

//Represents the neurofeedback protocol
//Responsible for interpreting the OSC data, 
//calculating results and moving through states
public class BaselineProtocol {

    private OscP5 osc;
    public NetAddress netAddress;
    public ApplicationState.Process p;

    //time intervals specified in minutes
    private int MINUTE = 60000;
    public int BASELINE_INTERVAL = 1;
    public int LINE_INTERVAL = 1;
    public int FEEDBACK_INTERVAL = 2;
    public int FEEDBACK2_INTERVAL = 1;
    public int FEEDBACK3_INTERVAL = 1;
    //reading task is indefinite
    
    private Timer timer;
    
    //OSC variables
    private String ipAdress = "127.0.0.1";
    private int portNumber = 9001;

    //temporary variable to check the number of received messages
    //should hold some averages / standar deviations etc.
    private int count;
    private float sum;
    private double mean;//mean value found during baseline
    
    public double getMean()
    {
      return mean;
    }
    
    public double getSd()
    {
      return sd;
    }
    
    //to be able to skip the baseline protocol
    public void setDebugValues(double mean, double sd)
    {
      this.mean = mean;
      this.sd = sd;
    }
    
    private double min;//min value found during baseline
    private double max;//max value found during baseline
    private double sd;//standard deviation

    //buffer for baseline values so we can calculate standard deviation
    //should be able to hold 1 minute worth of data, since we get 10 values each second, 
    //this should be around 10 * 60 = 600 datapoints, count should reflect this value
    private double[] buffer; //<>//
    
    private void fireStateChange()
    {
        if(this.app != null)
        {
          this.app.OnStateChange(p.getCurrentState());
        }
    }
    
    private void fireFeedbackValue(float value)
    { //<>//
        if(this.app != null)
        {
          this.app.OnFeedbackValue(value);
        }
    }

    //constructor set up OSC listening and perform initialization
    private FocusedAttentionExplorer app;//change this to name of app!
    BaselineProtocol(FocusedAttentionExplorer app) {
        this.app = app;
        
        netAddress = new NetAddress(ipAdress, portNumber);
        osc = new OscP5(this, portNumber);
        
        Init();
        p = new ApplicationState.Process();
    }
    
    //oscP5 callback, use for filtering
    void oscEvent(OscMessage message) {
      if (message.checkAddrPattern("/index") == true) {
        float index = message.get(0).floatValue();
        OnReceiveIndex(index);
      }
    }

    //we are subscribed to receiving theta/beta index values over osc
    void OnReceiveIndex(float theta_beta_index){
    
        //we only process the index values when we're in a recording state 
        switch (p.getCurrentState())
        {
            case Baseline_recording:
                ProcessBaselineValue(theta_beta_index); //<>//
                break;
            case Line_recording:
            case Feedback_recording:
            case Feedback2_recording:
            case Feedback3_recording:
            case Reading_task_recording:
                ProcessFeedbackValue(theta_beta_index);
                break;
        }
    }

    //called from UI or timers to proceed to move to the next stage
    public void ProceedState()
    {
      System.out.println("ProceedState called");
        try{
          
          p.MoveNext(ApplicationState.Command.Next); //<>//

          switch (p.getCurrentState())
          {
            case Init:
                Init();
                break;
            case Baseline_recording:
                StartTimer(BASELINE_INTERVAL);
                break;
            case Baseline_complete:
                OnBaselineComplete();
                break;
            case Line_recording:
                StartTimer(LINE_INTERVAL);
            case Feedback_recording:
                StartTimer(FEEDBACK_INTERVAL);
                break;
            case Feedback2_recording:
                StartTimer(FEEDBACK2_INTERVAL);
                break;
            case Feedback3_recording:
                StartTimer(FEEDBACK3_INTERVAL);
                break;
          }

          fireStateChange();//to notify any event listeners
        }
        catch(Exception e)
        {
          System.out.println("Failed to change state: " + e);
        }
    }

    //This timer should automatically 
    // call Proceed after a minute of collecting baseline data
    private class FeedbackTimerTask extends TimerTask
    {
      public void run()
      {
        timer.cancel();
        //call proceedstate on main thread?
        ProceedState();
      }
    }
    
    private void StartTimer(int minutes)
    {        
        int interval = minutes * MINUTE;
        timer = new Timer();
        timer.schedule(new FeedbackTimerTask(), interval);
    }

    //When the baseline is complete, we show some stuff we have calculated
    private void OnBaselineComplete()
    {
        //first truncate the buffer to the length of count
        
        double[] truncated = new double[count];
        System.arraycopy(buffer, 0, truncated, 0, count);
        Statistics s = new Statistics(truncated);
        
        mean = s.getMean();
        min = s.getMin();
        max = s.getMax();

        //float sumOfSquaresOfDifferences = truncated.Select(val => (val - mean) * (val - mean)).Sum();
        sd = s.getStdDev();

        System.out.println(String.format("baseline complete,n:%d  m:%f, sd:%f, min:%f, max:%f", count, mean, sd, min, max));
    }

    //reset all variables to their default
    private void Init()
    {
        count = 0;
        sum = 0;
        mean = 0;
        buffer = new double[(BASELINE_INTERVAL * MINUTE/100) + 100];//extra 100 for safety
    }

    //do something with a value received during baseline recording
    private void ProcessBaselineValue(float theta_beta_index)
    {
        System.out.println("received baseline value: " + theta_beta_index);
        buffer[count] = theta_beta_index;
        count++;
        sum += theta_beta_index;
    }

    //do something with a value received during feedback session
    private void ProcessFeedbackValue(float theta_beta_index)
    {
        fireFeedbackValue(theta_beta_index);//just pass it untouched
    }
}