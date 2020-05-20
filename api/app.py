#!/bin/python
from flask import Flask, request, jsonify, abort
from flask_cors import CORS
import json
import numpy as np
import base64
import requests

app = Flask(__name__)
CORS(app) # needed for cross-domain requests, allow everything by default

# Store transaction in-memory for now
transactions = [
]

# Thanks to https://stackoverflow.com/a/47626762
class NumpyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return json.JSONEncoder.default(self, obj)

# default route
@app.route('/')
def index():
    return "Nothing to see here!"

# HTTP Errors handlers
@app.errorhandler(400)
def url_error(e):
    return """
    Wrong URL!
    <pre>{}</pre>""".format(e), 404

@app.errorhandler(500)
def server_error(e):
    return """
    An internal error occurred: <pre>{}</pre>
    See logs for full stacktrace.
    """.format(e), 500

# Check a transaction for fraud
# { 'id': 1, 'image': 'b64 encoded string' }
@app.route('/api/v1.0/nsfw', methods=['POST'])
def nsfw():
    if not request.json:
        app.logger.error('request body must be JSON')
        abort(400)

    if not 'id' in request.json:
        app.logger.error('no id in request')
        abort(400)

    if not 'image' in request.json:
        app.logger.error('no image in request')
        abort(400)

    # need to convert to format tflow model input expects
    raw_image = request.json['image'].replace("data:image/jpeg;base64,", '');
    bin_image = base64.b64decode(raw_image)
    image_data = base64.urlsafe_b64encode(bin_image).decode("ascii")

    #app.logger.debug(json.dumps({"instances": [image_data]}, cls=NumpyEncoder))

    transaction = {
        'id': request.json['id'],
        'issfw': False
    }

    import config

    # call tfserving model
    #url = "http://localhost:8501/v1/models/test_model:predict"
    url = config.svc['tfserving_url']
    headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', 'Content-Type': 'text/plain', 'cache-control': "no-cache" } 
    req = json.dumps({"instances": [image_data]})
    response = requests.request("POST", url, data=req, headers=headers)
    
    nsfw = json.loads(response.text)
    #app.logger.debug(nsfw['predictions'][0])

    # if there is an error we failsafe here
    if response.status_code != 200:
        app.logger.error("tfserving call failed? ", response.text)
        return jsonify({'transaction': transaction}), 201

    transaction['sfw'] = nsfw['predictions'][0][0]
    transaction['nsfw'] = nsfw['predictions'][0][1]
    #app.logger.debug("sfw:\t{} nsfw:\t{}".format(*nsfw['predictions'][0]))
    
    # call kogito to make decision
    #url = "http://localhost:8081/nsfw"
    url = config.svc['kogito_url']
    headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', 'cache-control': "no-cache" } 
    req = json.dumps({"score": {"imageId": transaction['id'], "sfw": transaction['sfw'], "nsfw": transaction['nsfw']}})
    response = requests.request("POST", url, data=req, headers=headers)

    bus_nsfw = json.loads(response.text)
    app.logger.debug(bus_nsfw)

    if response.status_code != 200:
        app.logger.error("kogito call failed? ", response.text)
        return jsonify({'transaction': transaction}), 201

    transaction['issfw'] = bus_nsfw['score']['issfw']

    transactions.append(transaction)
    app.logger.debug(transaction)
    return jsonify(transaction), 201

# Get transactions that have been checked for nsfw
@app.route('/api/v1.0/nsfw/transactions', methods=['GET'])
def get_transactions():
    return jsonify({'transactions': transactions})


if __name__ == '__main__':
    app.run(host= '0.0.0.0', debug=True)
