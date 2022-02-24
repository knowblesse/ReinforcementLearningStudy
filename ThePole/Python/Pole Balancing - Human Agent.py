import sys, gym, time

env = gym.make('CartPole-v1')

human_agent_action = 0

def key_press(key, mod):
    global human_agent_action, human_wants_restart, human_sets_pause
    if key == ord('a'):
        human_agent_action = 0
    else:
        human_agent_action = 1
    return

env.render()
env.unwrapped.viewer.window.on_key_press = key_press

for _ in range(20):
    env.reset()
    env.render()
    done = False
    total_reward = 0
    while not done:
        print(human_agent_action)
        state, reward, _, info = env.step(human_agent_action)
        total_reward += reward
        env.render()
        time.sleep(0.01)
    print(f"{total_reward}")
