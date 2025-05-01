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
        # Get Walrus version
        version_result = subprocess.run(
            ["walrus", "--version"],
            capture_output=True,
            text=True,
            check=False
        )
        version_info = version_result.stdout.strip() if version_result.returncode == 0 else "Unknown"
        
        # Try to list all blobs
        list_result = subprocess.run(
            ["walrus", "list-blobs"],
            capture_output=True,
            text=True,
            check=False  # Don't raise exception on error
        )
        
        if list_result.returncode == 0 and list_result.stdout.strip():
            blobs = list_result.stdout.splitlines()
            blob_list = "<ul>" + "".join([f"<li>{blob}</li>" for blob in blobs]) + "</ul>"
        else:
            error_msg = list_result.stderr if list_result.stderr else "No blobs found"
            blob_list = f"<p>No blobs found or empty list returned</p><p><small>Details: {error_msg}</small></p>"
        
        # Try to store a blob directly from the endpoint
        store_result = subprocess.run(
            ["walrus", "store", "--epochs", "1", "/app/example.txt"],
            capture_output=True,
            text=True,
            check=False  # Don't raise exception on error
        )
        
        if store_result.returncode == 0:
            store_message = f"<p class='success'>Successfully stored blob: {store_result.stdout}</p>"
        else:
            store_message = f"<p class='error'>Failed to store blob: {store_result.stderr}</p>"
        
        html = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <title>Walrus Blob Storage</title>
            <style>
                body {{ font-family: Arial, sans-serif; margin: 20px; }}
                .success {{ color: green; }}
                .error {{ color: red; }}
                .info {{ color: blue; }}
                pre {{ background-color: #f5f5f5; padding: 10px; border-radius: 5px; }}
            </style>
        </head>
        <body>
            <h1>Walrus Blob Storage</h1>
            <p class="info">Using Walrus CLI version: {version_info}</p>
            
            <h2>Storage Test:</h2>
            {store_message}
            
            <h2>Existing Blobs:</h2>
            {blob_list}
            
            <hr>
            <p><small>Refresh this page to attempt storing the blob again</small></p>
        </body>
        </html>
        """
        return html
    except Exception as e:
        logger.error(f"Error in list_origins route: {str(e)}")
        return f"Error: {str(e)}", 500

if __name__ == "__main__":
    logger.info("Starting Flask app on port 8080")
    app.run(host="0.0.0.0", port=8080)
