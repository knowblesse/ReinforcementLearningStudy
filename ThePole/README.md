# The Pole
Pole Balancing Problem

## Objective
The main objective of this problem is to balance the pole attached to a cart by applying either right or left force to the cart.

## Environment
> (side note) Before the era of python, there was no easily accessble simulation environment for the problem. So I developed my own environment based on Matlab (**/Matlab/Pole_Balancing_Engine.m**) using **Reference.pdf**. However, now there is a well-made environment out there, **gym**, so I recommand using it rather than this one. Well... if you still prefer Matlab, than you are always welcome!
- Matlab : Own Environment. Uses double value Force as action. => Continuous Action Space
- Python : gym from OpenAI. Uses two integer (0 and 1) as action. => Discrete Action Space

## Method
### Matlab
#### GeneticAlgorithm
This script uses the genetic algorithm to solve the problem. It uses linear sum of four allele (a,b,c,d) to compute the force for the next action.

<img src="https://latex.codecogs.com/gif.latex?\large F  = ax + bx' + c\theta + d\theta'"/>

<img src="https://latex.codecogs.com/gif.latex?x\mathrm{:cart\ position,}\ x'\mathrm{:cart\ velocity,}\  \theta\mathrm{:pole\ angle,}\  \theta'\mathrm{:pole\ angular\ velocity}"/>

* Pole_Balancing_Engine.m : Main simulation engine
* Pole_Balancing_GeneticAlgorithm.m : Gene Selection script
* Pole_Balancing_LoadOptimal.m : Load the optimal gene (Opt_Gene.mat) and simulate
* Opt_Gene.mat : Optimal Gene File
* sortsel.m : helper function

### Python
#### Tabular Method
The most basic method for the problem. First, it collects sufficient amount of state data. Then it generate range for each state dimension and project each continuous states to a discrite dimension.
After the projection, tabular method is used to finite size of Q-table

* Pole Balancing - Tabular method.ipynb : jupyter-notebook version
* Pole Balancing - Tabular method - Class.py : python class

#### Learn from lucky episodes
Go random and save best episodes ("lucky episode"). Then train from this episode.

* Pole Balancing - Lucky episode method.ipynb

#### DQN
Uses Replay Memory and separated Target and Policy net.

* Pole Balancing - DQN.py
> reference : https://pytorch.org/tutorials/intermediate/reinforcement_q_learning.html
