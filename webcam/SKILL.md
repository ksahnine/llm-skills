---
name: transport-paris-idf
description: Take a picture using the agent's webcam.
metadata: {"nanobot":{"emoji":"🚌","os":["darwin","linux"],"requires":{"bins":["fswebcam"]}}}
---
# Webcam Skill

This skill provides the ability to capture images using the agent's webcam.

**Description:**
- Captures a photo from the installed webcam at 1280x720 resolution
- Saves the captured image to `/tmp/image.jpg`
- The image file can then be attached to messages or accessed programmatically

**Command:**
```bash
fswebcam -r 1280x720 --no-banner /tmp/image.jpg
```

**Parameters:**
- `-r 1280x720`: Sets the resolution to 1280x720 (HD quality)
- `--no-banner`: Disables fswebcam's default banner/text overlay
- `/tmp/image.jpg`: Output file path where the captured image is saved

**Usage Example:**
```
Take a photo of the current scene and save it as a file attachment.
```

**Response Format:**
- Returns the path to the captured image: `/tmp/image.jpg`
- The image can be attached to subsequent messages or accessed via the file system
