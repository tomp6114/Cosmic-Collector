# 🌟 Cosmic Collector

A fast-paced Flutter arcade game built with the Flame engine. Navigate through space, collect glowing stars, and dodge hostile enemies in this addictive cosmic adventure!

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Game](https://img.shields.io/badge/Flame-Engine-orange?style=for-the-badge)

## 🎮 Game Overview

**Cosmic Collector** is an action-packed arcade game where quick reflexes and strategic movement are key to survival. Control your blue spaceship through an endless cosmic field, collecting valuable stars while avoiding dangerous triangle enemies that relentlessly pursue you.

### ✨ Key Features

- **🎯 Intuitive Controls**: Simple tap-to-move mechanics
- **⭐ Dynamic Collectibles**: Rotating stars with smooth animations  
- **🔺 Smart AI Enemies**: Triangle enemies that actively hunt you down
- **📈 Progressive Difficulty**: Challenge increases as you collect more stars
- **🏆 Score System**: Compete with yourself to achieve higher scores
- **🔄 Quick Restart**: Instant game restart with a single tap

## 🎯 How to Play

1. **Move**: Tap anywhere on the screen to guide your character
2. **Collect**: Touch the rotating yellow stars to earn points (+10 each)
3. **Survive**: Avoid the red triangle enemies that chase you
4. **Score**: Try to collect as many stars as possible before getting caught
5. **Restart**: When caught, tap the screen to play again

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Device/Emulator for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/cosmic-collector.git
   cd cosmic-collector
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the game**
   ```bash
   flutter run
   ```

### Dependencies

The game uses minimal dependencies for optimal performance:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flame: ^1.10.1
```

## 🛠️ Technical Stack

- **Framework**: Flutter for cross-platform development
- **Game Engine**: Flame 2D game engine
- **Language**: Dart
- **Graphics**: Custom Canvas API rendering
- **Architecture**: Component-based game design

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Desktop** (Windows, macOS, Linux)

## 🎨 Game Components

### Player
- Blue circular character with smooth movement
- Tap-based navigation system
- Boundary collision detection

### Stars
- Rotating yellow collectibles
- Procedurally spawned at regular intervals
- Custom 5-pointed star graphics

### Enemies
- Red triangle pursuers with AI behavior
- Spawn probability increases with score
- Heat-seeking movement toward player

## 🔧 Development

### Project Structure
```
lib/
└── main.dart           # Complete game implementation
    ├── StarCollectorGame   # Main game class
    ├── Player             # Player component
    ├── Star               # Collectible star
    └── Enemy              # AI enemy
```

### Key Game Mechanics
- **Collision Detection**: Distance-based circular collision
- **Movement System**: Linear interpolation for smooth motion  
- **Spawn System**: Timer-based star generation
- **AI Behavior**: Vector-based enemy pursuit
- **State Management**: Game over and restart handling

## 🎮 Game Flow

1. Game starts with player in center
2. Stars spawn automatically every 1.5 seconds
3. Collecting stars increases score and enemy spawn chance
4. Enemies move toward player using pathfinding
5. Game ends on player-enemy collision
6. Tap to restart and try again

## 📈 Future Enhancements

- [ ] **Power-ups**: Shield, speed boost, star magnet
- [ ] **Sound Effects**: Collision sounds and background music
- [ ] **Visual Effects**: Particle systems and explosions
- [ ] **Game Modes**: Time attack, survival, endless
- [ ] **Customization**: Different player skins and themes
- [ ] **Achievements**: Unlock system for milestones
- [ ] **Leaderboards**: Local and online high scores

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Areas for Contribution
- Bug fixes and performance improvements
- New game mechanics and features
- UI/UX enhancements
- Code optimization and refactoring
- Documentation improvements

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing cross-platform framework
- **Flame Engine** for the powerful 2D game development tools
- **Dart Community** for excellent language support
- **Open Source Contributors** who inspire continuous learning

## 📞 Contact & Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/cosmic-collector/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/cosmic-collector/discussions)
- **Email**: your.email@example.com

---

<div align="center">
  
**⭐ Enjoyed the game? Give it a star! ⭐**

*Built with ❤️ using Flutter and Flame*

</div>

