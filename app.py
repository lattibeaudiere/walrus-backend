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
        # Display a simple message since we can't use the Walrus CLI properly in this version
        html = """
        <h1>Walrus CLI Configuration</h1>
        <p>The Walrus CLI version 1.22.1 has been configured with a basic Sui wallet.</p>
        <p>However, this version doesn't fully support the blob operations we need.</p>
        <p>Status: Configuration complete, but functionality limited by CLI version.</p>
        """
        return render_template_string(html)
    except Exception as e:
        logger.error(f"Error in list_origins route: {str(e)}")
        return f"Error: {str(e)}", 500

if __name__ == "__main__":
    logger.info("Starting Flask app on port 8080")
    app.run(host="0.0.0.0", port=8080)
