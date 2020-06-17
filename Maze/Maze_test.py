import numpy as np
from pathlib import Path
import time
import seaborn as sns
from matplotlib import pyplot as plt

# 사용할 Maze_*x*_table.txt 파일명을 입력
FILE_NAME = "Maze_30x30_table.txt"

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
            raise Exception("[ERROR] State table file loading error\n\
            Can not find <" + FILE_NAME + "> in " + str(Path("./").absolute()))

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
START_POINT = 0
END_POINT = 899

# Initialize random function
np.random.RandomState(seed=None)

# parameters
learning_rate = 1
e = 0.03
gamma = 0.99
numEpoch = 200

# Memory
value_function = np.zeros([END_POINT+1,4])
score = np.zeros([numEpoch,1])

# Learn
totalTime = time.time()
for epoch in np.arange(numEpoch):
    starttime = time.time()
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
            reward = 100
        elif nextState == currState:
            reward = -10
        else:
            reward = -1
        # Update Value
        value_function[currState,currAction] += learning_rate * (reward + gamma * np.max(value_function[nextState,:]) - value_function[currState,currAction])

        # Move to Next Trial
        score[epoch, 0] += 1
        #print(str(currState) + " : " + str(currAction))
        currState = nextState
    last_runtime = time.time() - starttime
    print("Epoch : " + str(epoch) + " : " + str(time.time() - starttime) + "sec | number of moves : " + str(score[epoch]))
print("====================================================")
print("Total Time : " + str(time.time() - totalTime) + "sec")
# fig = plt.figure(1)
# ax = fig.add_subplot(111)
# ax.plot(score)
#
# for i in range(np.size(score)):
#     if score[i,0] == 50:
#         ax.scatter(i,score[i,0], c='red')
#     elif score[i,0] == 40:
#         ax.scatter(i,score[i,0], c='blue')
#
# ax.set_xlabel('Epoch')
# ax.set_ylabel('Num Moves')
# ax.set_title('')
# fig.show()

sns.heatmap(np.max(value_function,axis=1).reshape(30,30),cmap='Blues')
plt.show()