import time
import random
import paho.mqtt.client as mqtt

BROKER = "localhost"
PORT = 1883
TOPICS = [
    "smartcoffee/temperature",
    "smartcoffee/pressure",
    "smartcoffee/humidity",
]


def on_connect(_client, _userdata, _flags, reason_code, _properties):
    if reason_code == 0:
        print(f"Connected to {BROKER}")
    else:
        print(f"Connection failed: {reason_code}")


def main():
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.on_connect = on_connect
    client.connect(BROKER, PORT, keepalive=60)
    client.loop_start()

    print("Publishing sensor data. Press Ctrl+C to stop.\n")
    try:
        while True:
            temperature = round(random.uniform(88.0, 96.0), 1)
            pressure = round(random.uniform(8.5, 9.5), 2)
            humidity = round(random.uniform(40.0, 65.0), 1)

            readings = zip(TOPICS, [temperature, pressure, humidity])
            for topic, value in readings:
                payload = str(value)
                client.publish(topic, payload, qos=0)
                print(f"  {topic}: {value}")

            print()
            time.sleep(3)
    except KeyboardInterrupt:
        print("Stopped.")
    finally:
        client.loop_stop()
        client.disconnect()


if __name__ == "__main__":
    main()
