from flask import Flask, request, render_template
import csv
import requests
import os

app = Flask(__name__)

# ENV / CONFIG
score_push_url_env_var_name = "SCORE_PUSH_URL"
score_push_url = ""
SCORES_FILE = "/data/scores.csv"

# Globals
scoring_done = False
score = 0
username = None
email = None

# Create data directory if it doesn't exist
os.makedirs(os.path.dirname(SCORES_FILE), exist_ok=True)

# Initialize CSV file if it doesn't exist
if not os.path.exists(SCORES_FILE):
    with open(SCORES_FILE, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['rank', 'username', 'email', 'score'])

# Get the Score Push URL (still keeping this for backward compatibility)
if os.getenv(score_push_url_env_var_name) is not None:
    score_push_url = os.environ['SCORE_PUSH_URL']
    print(f"External score push URL configured: {score_push_url}")
else:
    print(f"{score_push_url_env_var_name} not set, using local CSV storage only")


# Flask shit
@app.route('/hit')
def hit():
    global score, username, email
    if scoring_done:
        return "Scoring has finished!"

    username = request.args.get('username')
    email = request.args.get('email')

    score = score + 1
    return f"{score}"


@app.route('/score')
def getScore():
    global score
    return f"{score}"


@app.route('/time')
def getTime():
    return "Time endpoint disabled"


@app.route('/resettimer')
def resetTimer():
    return "Timer endpoint disabled"


@app.route('/status')
def status():
    global score, scoring_done
    return f"Username: {username}, Email: {email}, Score: {score}, Scoring Done: {scoring_done}"


@app.route('/test', methods=['post'])
def test():
    post_data = request.get_json()

    app.logger.warning(f"Received post data: {post_data}")

    return ""


@app.route('/done')
def done():
    global scoring_done
    scoring_done = True
    
    # Read all existing scores
    all_scores = []
    try:
        with open(SCORES_FILE, 'r', newline='') as file:
            reader = csv.reader(file)
            next(reader)  # Skip header
            for row in reader:
                if len(row) >= 4:
                    all_scores.append([int(row[0]), row[1], row[2], int(row[3])])
    except Exception as e:
        print(f"Error reading scores: {e}")
    
    # Add new score
    all_scores.append([0, username, email, score])  # rank will be calculated
    
    # Sort by score (descending)
    all_scores.sort(key=lambda x: x[3], reverse=True)
    
    # Assign ranks
    for i, score_row in enumerate(all_scores):
        score_row[0] = i + 1  # rank is position + 1
    
    # Rewrite entire CSV file with correct ranks and sorting
    with open(SCORES_FILE, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['rank', 'username', 'email', 'score'])
        for score_row in all_scores:
            writer.writerow(score_row)
    
    # Also try to send to external URL if configured
    if score_push_url:
        try:
            score_object = {
                'username': username,
                'email': email,
                'score': score
            }
            requests.post(score_push_url, json=score_object)
        except Exception as e:
            print(f"Failed to send score to external URL: {e}")

    return "OK! I've stopped counting the score and saved it."


@app.route('/scores/view')
def view_scores():
    scores = []
    try:
        with open(SCORES_FILE, 'r', newline='') as file:
            reader = csv.reader(file)
            next(reader)  # Skip header
            for row in reader:
                if len(row) >= 4:  # rank, username, email, score
                    scores.append(row)
    except Exception as e:
        print(f"Error reading scores file: {e}")
    
    # CSV is already sorted, just display it
    html = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Score History</title>
        <style>
            table { border-collapse: collapse; width: 100%; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            tr:nth-child(even) { background-color: #f2f2f2; }
            th { background-color: #4CAF50; color: white; }
        </style>
    </head>
    <body>
        <h1>Score History</h1>
        <table>
            <tr>
                <th>Rank</th>
                <th>Username</th>
                <th>Email</th>
                <th>Score</th>
            </tr>
    """
    
    for score_row in scores:
        html += f"""
            <tr>
                <td>{score_row[0]}</td>
                <td>{score_row[1]}</td>
                <td>{score_row[2]}</td>
                <td>{score_row[3]}</td>
            </tr>
        """
        
    html += """
        </table>
    </body>
    </html>
    """
    
    return html



if __name__ == "__main__":
    app.run()
