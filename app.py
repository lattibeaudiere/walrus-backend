from flask import Flask, render_template_string
import subprocess

app = Flask(__name__)

@app.route("/")
def list_origins():
    try:
        # Run the walrus CLI to list blobs
        result = subprocess.run(["walrus", "list-blobs"], capture_output=True, text=True)
        blobs = []
        for line in result.stdout.splitlines():
            # Adjust this filter if your output format is different
            if "origins" in line:
                blobs.append(line)
    except Exception as e:
        blobs = [f"Error: {e}"]

    html = """
    <h1>Files Tagged with 'origins'</h1>
    <ul>
    {% for blob in blobs %}
      <li>{{ blob }}</li>
    {% endfor %}
    </ul>
    """
    return render_template_string(html, blobs=blobs)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
