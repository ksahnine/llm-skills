---
name: webcam
description: Capture photos using the agent's webcam at 1280x720 resolution
metadata: {"nanobot":{"emoji":"📷","os":["darwin","linux"],"requires":{"bins":["fswebcam"]}}}
---
# Skill: Webcam

This skill provides the ability to capture images using the agent's webcam at 1280x720 resolution and save them to `/tmp/image.jpg`.

## Capabilities

- Capture a photo from the installed webcam at 1280x720 (HD) resolution
- Save the captured image to `/tmp/image.jpg`
- Attach the image to messages or access it programmatically

## Usage

Execute the `fswebcam` command via the `exec` tool call.

```bash
fswebcam -r 1280x720 --no-banner /tmp/image.jpg
```

**Parameters:**
- `-r 1280x720`: Sets the resolution to 1280x720 (HD quality)
- `--no-banner`: Disables fswebcam's default banner/text overlay
- `/tmp/image.jpg`: Output file path where the captured image is saved

**Output:** The command returns the path to the captured image: `/tmp/image.jpg`

## When to Use

Invoke this skill when the user asks to:
- Take a photo or capture an image
- Show what the webcam sees
- Take a picture of the current scene

## Error Handling

1. **Missing `fswebcam`:** If the command fails because `fswebcam` is not installed, inform the user and suggest installing it: `brew install fswebcam` (macOS) or `apt install fswebcam` (Linux).
2. **No camera detected:** If the command fails with a "Unable to find device" error, inform the user that no webcam was detected.
3. **Permission denied:** If the command fails with a permission error, advise the user to check camera permissions.

## Guidelines for the AI Agent

1. **Verify Prerequisites:** Before using this skill, ensure `fswebcam` is available by checking if the command exists.
2. **Attach the Image:** After capturing, attach `/tmp/image.jpg` to the response so the user can see the result.
3. **Confirm Capture:** Inform the user that the photo was taken and saved to `/tmp/image.jpg`.
