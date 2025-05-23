# 🎵 Spotify Clone

A full-stack Spotify-like music streaming application built using **Flutter** (client) and **FastAPI** (server). The app features user authentication, music upload, recent plays, liked songs, and an immersive music player — all integrated into a clean, modern UI inspired by Spotify.

---

## ✨ Features

- 🔐 Login/Signup: Secure token-based authentication.
- 🏠 Home Page: Displays recently played songs using Hive (local storage).
- ❤️ Library Page: View and manage all your liked songs.
- ⬆️ Upload Songs Page: Upload new tracks to the server.
- 🎚️ Music Slab: A persistent mini-player like Spotify.
- 🎵 Music Player Page: Full-featured player UI.
- 🧠 State Management: Efficient state control using Riverpod.
- 💾 Local Storage: Recent songs and favorites stored locally using Hive.
- 🔊 **Background Playback**: Music continues playing even when the app is minimized or closed.
- 🛎️ **Notification Controls**: Pause/Play/Drag player from the notification tray.

---

## 🛠️ Tech Stack

### 🖥️ Frontend (Client)
- [Flutter](https://flutter.dev/)
- [Riverpod](https://riverpod.dev/)
- [Hive](https://pub.dev/packages/hive_flutter/versions)
- Dart

### 🖧 Backend (Server)
- [FastAPI](https://fastapi.tiangolo.com/)
- [PostgreSQL](https://www.postgresql.org/)
- SQLAlchemy + Pydantic

---

## 📁 Folder Structure

```

Spotify-Clone/
├── client/    # Flutter frontend
└── server/    # FastAPI backend

````

---

## 🚀 Getting Started

### 🔧 Prerequisites

- Flutter 3.x
- Python 3.10+
- PostgreSQL installed and running
- Git

---

## ⚙️ Server Setup (FastAPI)

1. **Clone the repository**

   ```bash
   git clone https://github.com/TexZ-GenZ/Spotify-Clone.git
   cd Spotify-Clone/server


2. **Create a virtual environment**

   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**

   ```bash
   pip install -r requirements.txt
   ````

4. **Start the server**

   ```bash
   fastapi dev main.py
   ```

   The server will run on `http://127.0.0.1:8000`

---

## 📱 Client Setup (Flutter)

1. **Navigate to the client folder**

   ```bash
   cd client
   ```

2. **Install Flutter dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

   > Ensure that a device or emulator is connected and backend URL is properly configured.

---

## 📷 Screenshots

> *Screenshots of your Home, Library, Upload Page, Music Player Page and Notification are here.*

### 🏠 Home Page  
<img src="https://github.com/user-attachments/assets/4b494143-1538-4b6b-be76-10b9578fdbf5" width="300"/>

### 📚 Library Page  
<img src="https://github.com/user-attachments/assets/6b60dff7-6937-4f82-89df-59176773d1c3" width="300"/>

### ⬆️ Upload Page  
<img src="https://github.com/user-attachments/assets/519cf986-39d7-4e14-bf54-85d6d86abc0b" width="300"/>

### 🎧 Music Player  
<img src="https://github.com/user-attachments/assets/a9b2a31e-829b-4337-83db-588b927cd809" width="300"/>

### 🔔 Notification Controls  
<img src="https://github.com/user-attachments/assets/c9ef3410-4118-42a0-9145-54505257c776" width="300"/>


---

## 🧑‍💻 Author

**TexZ-GenZ**
GitHub: [@TexZ-GenZ](https://github.com/TexZ-GenZ)

---

## 📃 License

This project is licensed under the **MIT License**.

