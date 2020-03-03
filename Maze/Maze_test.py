import numpy as np
from pathlib import Path
from matplotlib import pyplot as plt
import seaborn as sns

# Set File Name
FILE_NAME = "Maze_30x30.txt" # Name of the state txt file
START_POINT = 0
END_POINT = 899

""" ###########################################################  """
""" Code below CAN be changed, but recommend to leave untouched. """
""" ###########################################################  """
class Maze:
    """
    Class for Maze Structure
    """
    state_table = []
    def __init__(self):
        try:
            self.state_table = np.loadtxt(Path("./"+FILE_NAME), dtype=int)
        except:
            print("[ERROR] State table file loading error")
            print("Can not find <" + FILE_NAME + "> in " + str(Path("./").absolute()))

    def getNextState(self, currState, action):
        """
        Return next state by
        :param currState: current state. starting from 0.
        :param action: selected action. 0~3
        :return: next state
        """
        if currState not in range(np.shape(self.state_table)[0]):
            raise Exception("wrong current state value")
        if action not in range(4):
                raise Exception("wrong action value")
        return(self.state_table[currState,action])

maze = Maze()

""" ###########################################################  """
""" Code above CAN be changed, but recommend to leave untouched. """
""" ###########################################################  """

""" Write your code below this line """

# Initialize random function
np.random.RandomState(seed=None)

# parameters
learning_rate = 0.3
e = 0.1
gamma = 0.98
numEpoch = 50

# Memory
value_function = np.zeros([END_POINT+1,4])
score = np.zeros([numEpoch,1])

# Learn
for epoch in np.arange(numEpoch):
    print("Epoch : " + str(epoch))
    # Initialize
    currState = START_POINT
    # Start
    while currState != END_POINT:
        # Select Best action
        best_action = np.argmax(value_function[currState,:])
        # Check if there are multiple best actions
        if np.sum(value_function[currState,:] == value_function[currState, best_action]) > 1: # if there are multiple best actions,
            best_action = np.random.choice(np.squeeze(
                np.where(value_function[currState, :] == value_function[currState, best_action])))# randomly choose one
        # Go Random?
        if np.random.rand(1) < e: # go random
            actionset = list(range(4))
            actionset.remove(best_action)
            currAction = np.random.choice(actionset)
        else:
            currAction = best_action
        # Move
        nextState = maze.getNextState(currState, currAction)
        # Check reward
        if nextState == END_POINT:
            reward = 10
        elif nextState == currState:
            reward = -1
        else:
            reward = 0
        # Update Value
        value_function[currState,currAction] += learning_rate * (reward + gamma * np.max(value_function[nextState,:]) - value_function[currState,currAction])
        # Move to Next Trial
        score[epoch, 0] += 1
        #print(str(currState) + " : " + str(currAction))
        currState = nextState

plt.plot(score)
plt.xlabel('Epoch')
plt.ylabel('Num Moves')
plt.show()

sns.heatmap(np.max(value_function,axis=1).reshape(14,14),cmap='Blues', annot=True)
plt.show()
