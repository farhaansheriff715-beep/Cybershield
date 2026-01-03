This project is named as cyber shield is a application developed using Flutter, aimed at protecting sensitive user data through a password-based locking mechanism. 

The idea behind the project was to create a simple yet effective way to store private notes securely on a mobile device.

We started the project by setting up a Flutter application with a clean structure, separating screens, services, providers, and themes. 

The core concept was to ensure that the vault remains inaccessible unless the user explicitly unlocks it.

To manage secure access, we implemented a password-based authentication system. On first launch, the user is asked to set a vault password. 

This password is encrypted and stored locally using Hive, a lightweight and fast local database. For encryption, we used AES encryption, ensuring that even if someone accesses local storage, the data remains unreadable.

Every time the app restarts, the vault is automatically locked. 

The user must re-enter the correct password to unlock it, which ensures persistent security across sessions. Incorrect passwords are rejected, preventing unauthorized access.

Once unlocked, the user can store secure notes inside the vault. 

Each note is encrypted before being saved and decrypted only when displayed, ensuring data protection at all times. 

The user also has the option to delete individual notes when they are no longer needed.

A key feature of the app is the manual “Lock Vault” button, which allows users to lock the vault again whenever they want, even while the app is still running. 

This gives users full control over their data security.

State management is handled using the Provider package, which keeps track of whether the vault is locked or unlocked across the app. 

The UI automatically switches between the Gatekeeper (lock screen) and the Vault screen based on this state.

The application follows a dark cyber-style theme with blue accents, improving readability and giving it a modern security-focused appearance. 

The UI is simple, clean, and user-friendly.

Overall, the best part of this project is its secure-by-design approach, combining encryption, local storage, and state management to protect user data effectively. It demonstrates practical knowledge of Flutter, local storage, encryption, and secure application design, making it a strong real-world project suitable for internships and learning purposes.