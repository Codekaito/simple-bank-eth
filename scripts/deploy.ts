// scripts/deploy.ts
import { ethers } from "hardhat";

async function main() {
  console.log("📢 Avvio deploy contratto SimpleBank...");

  // Imposta l'initial supply a 1 milione di token (con 18 decimali)
  const initialSupply = ethers.parseUnits("1000000", 18);
  console.log("✅ Initial supply impostato:", initialSupply.toString());

  // Otteniamo la factory del contratto
  const SimpleBank = await ethers.getContractFactory("SimpleBank");

  // Deploy del contratto con l'initialSupply come parametro
  const contract = await SimpleBank.deploy(initialSupply);
  console.log("⏳ Deploy in corso...");

  // Attesa del completamento del deploy
  await contract.waitForDeployment();
  console.log("🎉 Deploy completato con successo!");

  // Mostra l'indirizzo del contratto deployato
  console.log(`📍 SimpleBank è stato deployato su: ${contract.target}`);
}

// Gestione degli errori
main().catch((error) => {
  console.error("❌ Errore durante il deploy:", error);
  process.exitCode = 1;
});
