//ported from .net

import java.util.Map;
import java.util.HashMap;

public class ApplicationState
{
    //these are the states our application can be in
    public enum State
    {
        Init,
        Baseline_recording,
        Baseline_complete,
        Feedback_recording,
        Feedback_complete,
        Reading_task,
        Reading_task_complete
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
        private void setCurrentState(State state)
        {
          this._currentState = state;
        }

        //constructor
        public Process()
        {
            this.setCurrentState(State.Init);
            
            transitions = new HashMap<StateTransition, State>();
            
            //quick setup for just testing reading task, first baseline, then reading task
            /*transitions.put( new StateTransition(State.Init, Command.Next), State.Baseline_recording);
            transitions.put( new StateTransition(State.Baseline_recording, Command.Next), State.Baseline_complete );
            transitions.put( new StateTransition(State.Baseline_complete, Command.Next), State.Reading_task );
            transitions.put( new StateTransition(State.Reading_task, Command.Next), State.Reading_task_complete );
            transitions.put( new StateTransition(State.Reading_task_complete, Command.Next), State.Init);*/
            
            //original setup, first baseline, then feedback exercise, then reading task
            transitions.put( new StateTransition(State.Init, Command.Next), State.Baseline_recording);
            transitions.put( new StateTransition(State.Baseline_recording, Command.Next), State.Baseline_complete );
            transitions.put( new StateTransition(State.Baseline_complete, Command.Next), State.Feedback_recording );
            transitions.put( new StateTransition(State.Feedback_recording, Command.Next), State.Feedback_complete );
            transitions.put( new StateTransition(State.Feedback_complete, Command.Next), State.Reading_task );
            transitions.put( new StateTransition(State.Reading_task, Command.Next), State.Reading_task_complete );
            transitions.put( new StateTransition(State.Reading_task_complete, Command.Next), State.Init);
            
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