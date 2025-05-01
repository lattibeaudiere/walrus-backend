from flask import Flask, render_template_string, Response
import subprocess
import logging
import os

app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

@app.route("/list_origins", methods=['GET'])
def list_origins():
    logger.debug("list_origins route called")
    try:
        result = subprocess.run(
            ["walrus", "list-blobs", "--tag", "origins", "--config", "/root/.sui/client_config.yaml"],
            capture_output=True,
            text=True,
            check=True
        )
        logger.debug(f"walrus list-blobs output: {result.stdout}")
        blobs = result.stdout.splitlines()
        html = """
        <h1>Files Tagged with 'origins'</h1>
        <ul>
        {% for blob in blobs %}
          <li>{{ blob }}</li>
        {% endfor %}
        </ul>
        """
        return render_template_string(html, blobs=blobs)
    except subprocess.CalledProcessError as e:
        logger.error(f"Error running walrus list-blobs: {e.stderr}")
        return f"Error: {e.stderr}", 500

if __name__ == "__main__":
    logger.info("Starting Flask app on port 8080")
    app.run(host="0.0.0.0", port=8080)
