# 🎲 Monad Dice Game

A simple dice game built in Solidity and deployable on the Monad blockchain.  
Players guess a number between 1 and 6 and pay a fixed entry fee in MON (Monad's native token).  
If they guess correctly, they win the jackpot (minus a small house cut).

---

## ✨ Features

- 🎰 Fixed entry fee: 0.01 MON per game  
- 🎲 Random number generation (between 1 and 6)  
- 💰 Winner payout minus 10% house cut  
- 📊 Player statistics: games played, wins, losses, earnings  
- 🏆 Dynamic top 10 leaderboard  
- 🔐 Admin functions for owner to withdraw earnings and update settings  

---

## 📦 How to Deploy (Remix + Monad)

1. Open [Remix IDE](https://remix.ethereum.org)
2. Create a new file: `monaddicegame.sol`
3. Paste the Solidity contract code from this repo
4. Compile using **Solidity v0.8.24**
5. Deploy to Monad by connecting MetaMask with the Monad RPC URL

---

## 🧱 Project Structure

- `monaddicegame.sol` – Main smart contract
- `README.md` – This file
- `.gitignore` – To exclude non-essential files (optional)

---

## 👤 Author

Built with 💜 by [keizerh1](https://github.com/keizerh1)

---

## 📄 License

**This project is not open source at this time. All rights reserved.**

---

## 🚧 Future Plans

- 🎨 Web interface (React + ethers.js)
- 🔗 Full Web3 integration with MetaMask
- 👥 Multiplayer version
