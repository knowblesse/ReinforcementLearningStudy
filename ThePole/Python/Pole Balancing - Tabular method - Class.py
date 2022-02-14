import gym
import numpy as np
import time

"""
Pole Balancing - Tabular method - Class
"""

class ThePole:
    def __init__(self, binning_criterion, start_down = False):
        self.binning_criterion = binning_criterion
        self.env = gym.make('CartPole-v0')
        self.state = self.env.reset()
        self.binsize = self.binning_criterion.shape[0]+1
        self.value_function = np.random.standard_normal((self.binsize, self.binsize, self.binsize, self.binsize, 2))
        self.block_number = 100
        self.overallEpoch = 0
        self.start_down = start_down
    def train(self,num_epoch = 1000, lr = 0.01, lr_decrease = False, lr_min = 0.001, e = 0.2, e_decrease = False, e_min = 0, gamma = 0.99):
        # setup learning parameters
        if type(lr) is not np.ndarray:
            if lr_decrease:
                lr = np.linspace(lr, lr_min, num_epoch)
            else:
                lr = np.linspace(lr, lr, num_epoch)
        if type(e) is not np.ndarray:
            if e_decrease:
                e = np.linspace(e, e_min, num_epoch)
            else:
                e = np.linspace(e, e, num_epoch)
        # performance variables
        reward_block = np.zeros(self.block_number)
        combo_block = np.zeros(self.block_number)
        action_block = np.zeros(self.block_number)

        # Train
        train_start_time = time.time()
        for epoch in np.arange(num_epoch):
            self.env.reset()
            if self.start_down:
                self.env.state[2] = np.pi
            state = self.env.state
            table_index = self.getQtableIndex(state)

            finish = False

            reward_block[epoch%self.block_number] = 0
            combo_block[epoch%self.block_number] = 1
            action_block[epoch%self.block_number] = 1

            isUpright = False

            # Run until the simulation finish
            while not finish:
                current_values = self.value_function[table_index[0], table_index[1], table_index[2], table_index[3], :]

                # Go Random?
                if np.random.rand(1) < e[epoch]:  # go random
                    currAction = np.random.choice(np.array([0, 1], dtype=int))
                else:  # select the best action
                    best_action = np.argmax(current_values)
                    if np.sum(current_values == current_values[best_action]) > 1:  # if there are multiple best actions,
                        best_action = np.random.choice(np.array([0, 1], dtype=int))  # randomly choose one
                    currAction = best_action

                # Do action
                new_state, _, _, _ = self.env.step(currAction)

                # Calculate Reward
                if (np.abs(state[0]) > 2.4) or (np.abs(state[2]) > 0.3):
                    reward = -1000
                    finish = True
                else:
                    reward = 5
                    if action_block[epoch%self.block_number] > 300:
                        finish = True

                # Update Value
                new_table_index = self.getQtableIndex(new_state)
                action_block[epoch%self.block_number] += 1
                reward_block[epoch%self.block_number] += reward
                self.overallEpoch += 1

                self.value_function[table_index[0], table_index[1], table_index[2], table_index[3], currAction] += lr[epoch] * ((reward + gamma * np.max(self.value_function[new_table_index[0], new_table_index[1], new_table_index[2], new_table_index[3], :])) - current_values[currAction])

                # Move to the next Trial
                table_index = new_table_index
                state = new_state
            if (epoch % 100 == 0) and (epoch != 0):
                epochtime = time.time()
                print('Epoch : %04d : %5f sec | mean actions : %.2f | mean reward : %.2f | mean combo : %.2f' % (epoch, time.time() - epochtime, np.mean(action_block), np.mean(reward_block), np.mean(combo_block)))
                print("=========================================================================")

        print("Total Time : " + str(time.time() - train_start_time) + "sec")

    def simulate(self):
    # setup learning parameters
        self.env.reset()
        if self.start_down:
            self.env.state[2] = np.pi
        state = self.env.state
        table_index = self.getQtableIndex(state)
        finish = False

        tot_reward = 0
        combo = 1
        tot_action = 1

        # Run until the simulation finish
        while not finish:
            current_values = self.value_function[table_index[0], table_index[1], table_index[2], table_index[3], :]

            best_action = np.argmax(current_values)
            if np.sum(current_values == current_values[best_action]) > 1:  # if there are multiple best actions,
                best_action = np.random.choice(np.array([0, 1], dtype=int))  # randomly choose one
            currAction = best_action

            self.env.render()

            # Do action
            new_state, _, _, _ = self.env.step(currAction)

            # Calculate Reward
            if (np.abs(state[0]) > 2.4) or tot_action > 300:
                finish = True
            else:
                if (not self.start_down) and (np.abs(state[2]) > 0.3):
                    finish = True

            # Update Value
            new_table_index = self.getQtableIndex(new_state)
            tot_action += 1

            # Move to the next Trial
            table_index = new_table_index
            state = new_state
        print("Actions : %d" % (tot_action))
        self.env.close()

    def getQtableIndex(self,state):
        result = np.zeros((4,),dtype=int)
        for dim in np.arange(4):
            if (dim == 2) and (np.abs(state[2]) > (np.pi/2)):
                result[dim] = len(np.where(self.binning_criterion[:, dim] < np.sign(state[dim])*(np.pi - np.abs(state[dim])))[0])  # using the binning_criterion, decide the table index of the given state
            else:
                result[dim] = len(np.where(self.binning_criterion[:, dim] < state[dim])[0])  # using the binning_criterion, decide the table index of the given state
        return result


## State Bucket
state_bucket = np.zeros((0, 4))

env = gym.make('CartPole-v0')
for i in np.arange(100):
    state = env.reset()
    finish = False
    state_bucket = np.vstack((state_bucket, state))
    while not finish:
        state, reward, finish, _ = env.step(env.action_space.sample())
        state_bucket = np.vstack((state_bucket, state))

# Binning
Number_of_bin = 6
bucket_size = state_bucket.shape[0]
binning_criterion = np.zeros((Number_of_bin-1,4))
cutting_index = np.round(np.linspace(0,bucket_size-1,Number_of_bin-1)).astype(np.int)

# for each dimension
for dim in np.arange(4):
    sorted = np.sort(state_bucket[:,dim]) # sort all observed states in ascending order
    binning_criterion[:,dim] = sorted[cutting_index] # cut them with the same spacing

myPole = ThePole(binning_criterion)
myPole.train(num_epoch=2000, lr=0.05, lr_decrease=True, e=0.2, e_decrease=True)