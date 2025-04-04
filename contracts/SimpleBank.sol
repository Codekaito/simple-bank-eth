// SPDX-License-Identifier: MIT

pragma solidity =0.8.29;

// Importazione del contratto ERC20 di OpenZeppelin, che implementa lo standard ERC-20
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleBank is ERC20 {
    // Definizione di un errore personalizzato per gestire i casi di prelievo non valido
    error InvalidAmount(uint256 amount, uint256 currentUserBalance);

    // Eventi per tracciare i depositi e i prelievi effettuati nel contratto
    event Deposited(address indexed from, address indexed to, uint256 amount);
    event Withdrawn(address indexed from, uint256 amount);

    // Il costruttore inizializza il contratto ERC20 con nome e simbolo per il token
    constructor(uint256 initialSupply) ERC20("SimpleBank", "SBANK") {
        _mint(msg.sender, initialSupply);
    }

    /**
     * @dev Funzione che consente a un utente di depositare Ether nel contratto.
     * I token SBANK equivalenti all'importo di Ether depositato vengono "mintati" (creati)
     * e assegnati all'indirizzo dell'utente.
     */
    function deposit() external payable {
        // Mint dei token per l'indirizzo dell'utente, con la stessa quantità di Ether inviata
        _mint(msg.sender, msg.value);

        // Evento che traccia il deposito effettuato dall'utente
        emit Deposited(msg.sender, msg.sender, msg.value);
    }

    /**
     * @dev Funzione che consente a un utente di depositare Ether nel contratto
     * per conto di un altro utente (recipiente). I token SBANK equivalenti
     * all'importo di Ether depositato vengono "mintati" e inviati al destinatario.
     */
    function depositFor(address recipient) external payable {
        // Mint dei token per l'indirizzo del destinatario, con la stessa quantità di Ether inviata
        _mint(recipient, msg.value);

        // Evento che traccia il deposito effettuato per conto del destinatario
        emit Deposited(msg.sender, recipient, msg.value);
    }

    /**
     * @dev Funzione che consente a un utente di prelevare una quantità di token dal contratto.
     * La quantità di token prelevata viene bruciata (burned) e l'utente riceve
     * una quantità corrispondente di Ether.
     * 
     * @param amount L'importo dei token che l'utente desidera prelevare.
     */
    function withdraw(uint256 amount) external {
        // Seguiamo il pattern "Checks-Effects-Interactions" per evitare attacchi come reentrancy

        // INIZIO: Verifica che l'utente abbia abbastanza token per prelevare
        uint256 currentUserBalance = balanceOf(msg.sender);  // Recuperiamo il saldo dell'utente (già disponibile con ERC20)
        
        // Verifica che l'importo sia valido (maggiore di zero e non superiore al saldo dell'utente)
        require(0 < amount && amount <= currentUserBalance, InvalidAmount(amount, currentUserBalance));
        
        // DOPODICHÉ: Aggiorniamo lo stato del contratto (bruciamo i token dell'utente)
        _burn(msg.sender, amount);
        
        // INFINE: Trasferiamo la quantità equivalente di Ether all'utente
        payable(msg.sender).transfer(amount);
        
        // Emitto l'evento per tracciare il prelievo
        emit Withdrawn(msg.sender, amount);
    }
}
