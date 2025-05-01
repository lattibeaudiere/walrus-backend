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
        # Try to list all blobs
        result = subprocess.run(
            ["walrus", "list-blobs"],
            capture_output=True,
            text=True,
            check=False  # Don't raise exception on error
        )
        
        if result.returncode == 0 and result.stdout.strip():
            blobs = result.stdout.splitlines()
            blob_list = "<ul>" + "".join([f"<li>{blob}</li>" for blob in blobs]) + "</ul>"
        else:
            error_msg = result.stderr if result.stderr else "No blobs found or command not supported"
            blob_list = f"<p>Could not list blobs: {error_msg}</p>"
        
        # Try to store a blob directly from the endpoint
        store_result = subprocess.run(
            ["walrus", "store", "--epochs", "1", "/app/example.txt"],
            capture_output=True,
            text=True,
            check=False  # Don't raise exception on error
        )
        
        if store_result.returncode == 0:
            store_message = f"<p>Successfully stored blob: {store_result.stdout}</p>"
        else:
            store_message = f"<p>Failed to store blob: {store_result.stderr}</p>"
        
        html = f"""
        <h1>Walrus Blob Storage</h1>
        <h2>Storage Test:</h2>
        {store_message}
        <h2>Existing Blobs:</h2>
        {blob_list}
        """
        return render_template_string(html)
    except Exception as e:
        logger.error(f"Error in list_origins route: {str(e)}")
        return f"Error: {str(e)}", 500

if __name__ == "__main__":
    logger.info("Starting Flask app on port 8080")
    app.run(host="0.0.0.0", port=8080)
