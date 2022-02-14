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
        self.gamma = 0.995  # reward discounting
        self.epsilon = [0.5, 0.05]
        self.train_size = 200

        # Q function
        args = dict()
        args['device'] = self.device
        self.policy_net = SimpleDQN(args).to(self.device)
        self.target_net = SimpleDQN(args).to(self.device)
        self.target_net.load_state_dict(self.policy_net.state_dict())
        self.target_net.eval()

        self.optimizer = torch.optim.RMSprop(self.policy_net.parameters())

        # Agent Parameters
        self.numStep = 1
        self.last_state = None
        self.last_action = None
        self.Memory = ReplayMemory(10000)  # replay memory for learning

        # Agent Metrics
        self.score = deque([], maxlen=50)
        self.numTrain = 0
        self.bestScore = 0

        self.env = gym.make('CartPole-v1')
        self.state = self.env.reset()

    def train(self, numTrain):
        self.score.clear()
        for step in range(numTrain):
            self.state = list(self.env.reset())
            self.numStep = 1
            done = False
            self.last_state = None
            while not done:
                reward = 1
                # Calculate the values
                if np.random.rand() < self.epsilon[1] + (self.epsilon[0] - self.epsilon[1])*(numTrain-step)/numTrain:
                    action = random.choice([0,1])
                else:  # Go Softmax
                    with torch.no_grad():
                        action = self.policy_net.forward(torch.tensor(self.state, dtype=torch.float32)).max(0)[1].item()

                # Save to the Replay Memory
                if self.last_state is not None:
                    self.Memory.push(
                        self.last_state,
                        self.last_action,
                        reward,
                        self.state)

                self.last_state = self.state
                self.last_action = action

                self.state, _, done, _ = self.env.step(action)
                self.state = list(self.state)
                self.numStep += 1

            # Save to the Replay Memory
            if self.last_state is not None:
                self.Memory.push(
                    self.last_state,
                    self.last_action,
                    0,
                    None)

            if len(self.Memory) > 1000:
                self.trainNet()
                self.numTrain += 1

            if step %30 == 0:
                self.target_net.load_state_dict(self.policy_net.state_dict())
            self.score.append(self.numStep)
            print(f'{self.numTrain} : {np.mean(self.score)}, : {self.numStep}')

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
        next_state_values[non_final_mask] = torch.max(self.target_net.forward(non_final_next_states).detach(),1).values

        loss_fn = nn.SmoothL1Loss()
        loss = loss_fn(self.policy_net.forward(S).gather(1, A), R + self.gamma * next_state_values.unsqueeze(1))
        self.optimizer.zero_grad()
        loss.backward()
        for param in self.policy_net.parameters():
            param.grad.clamp_(-1,1)
        self.optimizer.step()

    def run(self, numRun):
        for step in range(numRun):
            self.state = list(self.env.reset())
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
            30)
        self.fc3 = nn.Linear(
            30,
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
p.train(1000)
p.run(10)