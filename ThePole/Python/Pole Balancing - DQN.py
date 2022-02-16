import numpy as np

from collections import deque, namedtuple
import torch
import torch.nn as nn
import torch.nn.functional as F

import random
import gym

SARN = namedtuple('SARV', ('state', 'action', 'reward', 'next_state'))

class ReplayMemory(object):
    def __init__(self, capacity):
        self.memory = deque([], maxlen=capacity)

    def push(self, *args):
        self.memory.append(SARN(*args))

    def sample(self, sample_size):
        return random.sample(self.memory, sample_size)

    def __len__(self):
        return len(self.memory)


class PoleDQN():

    def __init__(self):
        # Fixed Parameters
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.gamma = 0.99  # reward discounting
        self.initial_epsilon = 1
        self.epsilon = self.initial_epsilon
        self.train_size = 256
        self.initial_lr = 0.01

        # Q function
        args = dict()
        args['device'] = self.device
        self.policy_net = SimpleDQN(args).to(self.device)

        self.optimizer = torch.optim.Adam(self.policy_net.parameters(), lr=self.initial_lr, eps=1e-4)

        # Agent Parameters
        self.numTrain = 0
        self.numStep = 0

        self.score_history = []
        self.rollingScore = deque([], maxlen=10)

        self.last_state = None
        self.Memory = ReplayMemory(40000)  # replay memory for learning

        self.env = gym.make('CartPole-v0')


    def train(self, totTrain):
        for episode in range(totTrain):
            self.state = list(self.env.reset())
            self.last_state = self.state
            self.numStep = 1
            done = False

            while not done:
                # Select Action
                if np.random.rand() < self.epsilon:
                    action = random.choice([0,1])
                else:
                    self.policy_net.eval() # set the policy net to evaluation mode
                    with torch.no_grad():
                        action = self.policy_net(torch.tensor(self.state, dtype=torch.float32)).max(0)[1].item()
                    self.policy_net.train() # set the policy net back into training mode

                # Conduct Action
                self.state, reward, done, _ = self.env.step(action)
                self.state = list(self.state)

                # Save to the Replay Memory
                if done:
                    self.Memory.push(
                        self.last_state,
                        action,
                        0,
                        None)
                else:
                    self.Memory.push(
                        self.last_state,
                        action,
                        reward,
                        self.state)

                if len(self.Memory) > 256:
                    self.trainNet()
                    self.numTrain += 1

                # Update Learning Rate
                if np.mean(self.score_history) > 0.75 * 195:
                    new_lr = self.initial_lr / 100.0
                elif np.mean(self.score_history) > 0.6 * 195:
                    new_lr = self.initial_lr / 20.0
                elif np.mean(self.score_history) > 0.5 * 195:
                    new_lr = self.initial_lr / 10.0
                elif np.mean(self.score_history) > 0.25 * 195:
                    new_lr = self.initial_lr / 2.0
                else:
                    new_lr = self.initial_lr
                for g in self.optimizer.param_groups:
                    g['lr'] = new_lr

                # Update Epsilon
                self.epsilon = self.initial_epsilon / (1.0 + (self.numStep))

                self.last_state = self.state
                self.numStep += 1

            self.score_history.append(self.numStep)
            self.rollingScore.append(self.numStep)
            print(f'Episode:{episode:3d} numTrain:{self.numTrain:5d} score:{self.numStep:3d} rollingScore:{np.mean(self.rollingScore)}')

    def trainNet(self):
        # generate train batch (from replay memory)
        sample = self.Memory.sample(self.train_size)
        sample = SARN(*zip(*sample))

        S = torch.tensor(sample.state, dtype=torch.float32, device=self.device)
        A = torch.tensor(sample.action, device=self.device).unsqueeze(1)
        R = torch.tensor(sample.reward, dtype=torch.float32, device=self.device).unsqueeze(1)
        N = sample.next_state

        non_final_mask = torch.tensor(tuple(map(lambda s: s is not None, sample.next_state)), device=self.device, dtype=torch.bool)
        non_final_next_states = torch.tensor([s for s in N if s is not None], device=self.device, dtype=torch.float32)

        next_state_values = torch.zeros(self.train_size, device=self.device)
        next_state_values[non_final_mask] = torch.max(self.policy_net(non_final_next_states).detach(),1).values

        self.optimizer.zero_grad()
        loss = F.mse_loss(self.policy_net(S).gather(1, A), R + self.gamma * next_state_values.unsqueeze(1))

        loss.backward()
        torch.nn.utils.clip_grad_norm_(self.policy_net.parameters(), 0.7)
        self.optimizer.step()

    def run(self, numRun):
        for step in range(numRun):
            self.state = self.env.reset()
            self.env.render()
            self.numStep = 1
            done = False
            self.last_state = None
            while not done:
                with torch.no_grad():
                    action = self.policy_net.forward(torch.tensor(self.state, dtype=torch.float32)).max(0)[1].item()

                self.state, _, done, _ = self.env.step(action)
                self.state = list(self.state)
                self.env.render()
                self.numStep += 1

class SimpleDQN(nn.Module):
    def __init__(self, params):
        # init. super
        super(SimpleDQN, self).__init__()

        # save params
        self.device = params['device']

        # basic building blocks
        self.fc1 = nn.Linear(
            4,
            30)
        self.fc2 = nn.Linear(
            30,
            15)
        self.fc3 = nn.Linear(
            15,
            2)

    def forward(self, x):
        x = x.to(self.device)

        x = self.fc1(x)
        x = F.relu(x)

        x = self.fc2(x)
        x = F.relu(x)

        x = self.fc3(x)

        return x

p = PoleDQN()
p.train(200)
p.run(10)
p.env.close()