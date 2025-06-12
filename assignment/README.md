# KubeDoom

You have **5 minutes** to:
1. Fix the deployment
2. Shoot as many demons (pods) as possible

## Fix the deployment 🛠️

Fix the deployment in this directory to spawn demons in Doom.
- You can use `kubectl edit` directly
- You can use `kubectl apply -f ./monster/deployment.yaml`
- You can use `kubectl apply -k .`

## Start shooting 🔫

When you have fixed the deployment, demons start to spawn inside Doom.
Play doom by connecting with VNC to: `localhost:5900`

A shortcut of VNCViewer is created on de desktop. 

- Press Space to open doors
- Use arrow keys to move
- Press Control to shoot 

Shoot the demons to score points.

If you haven't fixed the deployment before time runs out, you won't score any points!

Good Luck!