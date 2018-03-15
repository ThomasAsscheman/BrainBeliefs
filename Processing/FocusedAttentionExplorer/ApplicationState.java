//ported from .net

import java.util.Map;
import java.util.HashMap;

public class ApplicationState
{
    //these are the states our application can be in
    public enum State
    {
        Init,//Intro
        Baseline_start,
        Baseline_recording,
        Baseline_complete,
        Line_start,
        Line_recording,
        Line_complete,
        Feedback_start,
        Feedback_recording,
        Feedback_complete,
        Focus_tips,
        Feedback2_start,
        Feedback2_recording,
        Feedback2_complete,
        Feedback3_start,
        Feedback3_recording,
        Feedback3_complete,
        Reading_task_start,
        Reading_task_recording,
        End
    }

    //Next just proceeds to the next state, our machine is very simple and linear
    public enum Command
    {
        Next
    }

    //nested inner class
    public static class Process
    {
        class StateTransition
        {
            State CurrentState;
            Command Command;

            public StateTransition(State currentState, Command command)
            {
                CurrentState = currentState;
                Command = command;
            }

            @Override
            public int hashCode()
            {
                return 17 + 31 * CurrentState.hashCode() + 31 * Command.hashCode();
            }
            
            @Override
            public boolean equals(Object obj)
            {
                StateTransition other = (StateTransition) obj;
                return other != null && this.CurrentState == other.CurrentState && this.Command == other.Command;
            }
        }

        Map<StateTransition,State> transitions = new HashMap<StateTransition,State>();
        
        private State _currentState;
        public State getCurrentState()
        {
          return this._currentState;
        }
        
        public void setCurrentState(State state)
        {
          this._currentState = state;
        }

        //constructor
        public Process()
        {
            this.setCurrentState(State.Init);
            
            transitions = new HashMap<StateTransition, State>();
            
            //since all transitions are lineair, no need to spell it out manually
            //we just follow the order of the State enum
            State prev = null;
            for (State state : State.values())
            {
                if(prev != null)
                {
                  transitions.put ( new StateTransition(prev, Command.Next), state);
                }
                prev = state;
            }
            
            //complete the loop
            transitions.put( new StateTransition(State.End, Command.Next), State.Init);
            
        }

        public State GetNext(Command command) throws Exception
        { //<>//
            StateTransition transition = new StateTransition(this.getCurrentState(), command); //<>//
            State nextState = transitions.get(transition);
            
            if (nextState == null)
                throw new Exception("Invalid transition: " + this.getCurrentState() + " -> " + command);
                
            return nextState;
        }

        public State MoveNext(Command command) throws Exception //rethrow
        {
            this.setCurrentState(GetNext(command)); //<>//
            return this.getCurrentState();
        }
    }
  }