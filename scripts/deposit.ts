import { ethers } from "hardhat";
import * as dotenv from "dotenv";

dotenv.config();

async function main() {
  // Indirizzo del contratto già deployato su Sepolia (sostituiscilo col tuo)
  const contractAddress = "0x6b42f17315489bC4eCa5CB55385F997cb8471599";

  // Connettiamoci al wallet usando la private key e il provider di Alchemy
  const provider = new ethers.JsonRpcProvider(process.env.ALCHEMY_API_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!, provider);

  // Attacchiamo il contratto
  const SimpleBank = await ethers.getContractFactory("SimpleBank", wallet);
  const contract = SimpleBank.attach(contractAddress);

  console.log("📤 Invio di 0.8 ETH in corso...");

  // Invio di 1 Ether al contratto chiamando la funzione deposit()
  const tx = await contract.deposit({ value: ethers.parseEther("0.8") });

  console.log("⏳ Transazione in attesa di conferma...");
  await tx.wait();

  console.log(`✅ Deposit completato! Hash: ${tx.hash}`);
}

main().catch((error) => {
  console.error("❌ Errore durante il deposito:", error);
  process.exitCode = 1;
});
