import gym
import time
import random
import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import matplotlib.pyplot as plt

gpus = tf.config.experimental.list_physical_devices('GPU')
if gpus:
  try:
    tf.config.experimental.set_memory_growth(gpus[0], True)
  except RuntimeError as e:
    # 프로그램 시작시에 메모리 증가가 설정되어야만 합니다
    print(e)

model = keras.Sequential(
    [
        keras.Input(shape=(4,)),
        layers.Dense(200, activation="relu", kernel_initializer=keras.initializers.random_normal(mean=1)),
        layers.Dense(200, activation="relu", kernel_initializer=keras.initializers.random_normal(mean=1)),
        layers.Dense(2,name='output')
    ]
)

model.compile(
    optimizer=keras.optimizers.SGD(learning_rate = 0.001),
    loss=keras.losses.MeanSquaredError(),
    metrics=[keras.metrics.MeanSquaredError()]
    )
model.summary()
# Constants
STOP_CRT = 1000
EPSILON = 0.1
DISCOUNT = 0.999
EPOCH = 3000
BATCH_SIZE = 16
# Generate Environment
env = gym.make('CartPole-v1')

# For Every Learning Iterations
history = []

best = 0

for l in np.arange(EPOCH):
    state = env.reset()
    state = tf.convert_to_tensor(state)
    state = tf.expand_dims(state, 0)

    num_step = 0
    num_action = np.zeros([2,], dtype=int)
    done = False
    while (not done) and (num_step < STOP_CRT):
        value = model(state)
        #select action
        if np.random.rand(1) < EPSILON:
            action = np.random.randint(0,2)
        else:
            action = np.argmax(value)
        num_action[action] += 1
        new_state, reward, done, _ = env.step(action)
        new_state = tf.convert_to_tensor(new_state)
        new_state = tf.expand_dims(new_state,0)


        history.append([state, action, new_state, int(done)])

        state = new_state
        num_step += 1

    print("Episode : {0} | score : {1} | best : {2} | {3} vs {4}".format(l, num_step, best, int(num_action[0]), int(num_action[1])))
    # Check Max Performance
    if best < num_step :
        best = num_step
    if len(history) > 5000:
        sample_batch = random.sample(history, BATCH_SIZE)
        list_state, list_action, list_new_state, list_done = [], [], [], []
        for s, a, n_s, d in sample_batch:
            list_state.append(s)
            list_action.append(a)
            list_new_state.append(n_s)
            list_done.append(d)
        value = (1-np.array(list_done)) + (DISCOUNT * np.amax(model(tf.convert_to_tensor(list_new_state)),2))
        list_predicted_value = model.predict(np.array(list_state))
        list_predicted_value[np.arange(BATCH_SIZE),np.zeros((BATCH_SIZE,1),dtype=int),list_action] = value
        model.fit(tf.convert_to_tensor(list_state),list_predicted_value,verbose=1,epochs=1)
        del(history[0:(len(history)-5000)])


print(model.get_weights())

state = env.reset()
state = tf.convert_to_tensor(state)
state = tf.expand_dims(state, 0)
env.render()
print(model(state))




# Generate Environment
state = env.reset()
# For Every Learning Iterations
done = False
playtime = 0
while not done:
    state = state.reshape([-1, 4])
    values = model(state)
    action =  np.argmax(values)
    state, _, done, _ = env.step(action)
    env.render()
    time.sleep(0.01)
    playtime += 1
print(playtime)
env.close()
