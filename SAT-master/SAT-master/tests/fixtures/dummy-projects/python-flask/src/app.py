from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/health")
def health():
    return jsonify(status="ok")


@app.get("/add/<int:a>/<int:b>")
def add(a, b):
    return jsonify(sum=a + b)
